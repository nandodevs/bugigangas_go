import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/package_model.dart';
import '../domain/tracking_event.dart';

part 'package_repository.g.dart';

/// Repository for fetching package tracking data.
///
/// Uses the Correios RapidAPI when a valid key is configured in `.env`.
/// Falls back to realistic mock data when no valid key is found or when
/// the API call fails.
class PackageRepository {
  final Dio _dio;
  final String? _rapidApiKey;
  final String? _rapidApiHost;

  PackageRepository(this._dio, [this._rapidApiKey, this._rapidApiHost]);

  /// Returns `true` if a real RapidAPI key is configured.
  bool get _hasValidKey =>
      _rapidApiKey != null &&
      _rapidApiKey.isNotEmpty &&
      _rapidApiKey != 'minha_key_aqui';

  /// Returns a [PackageModel] for the given [trackingCode].
  Future<PackageModel> getPackage(String trackingCode) async {
    // Try real API if configured
    if (_hasValidKey) {
      try {
        final response = await _dio.get(
          '/track',
          queryParameters: {
            'tracking_code': trackingCode,
            'confidence_level': 'high',
          },
          options: Options(headers: {
            'x-rapidapi-host': _rapidApiHost,
            'x-rapidapi-key': _rapidApiKey,
          }),
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data as Map<String, dynamic>;
          return _parseCorreiosResponse(data);
        }
      } catch (e) {
        debugPrint('Correios API error, falling back to mock: $e');
      }
    }

    // Fallback to mock data
    return _getMockPackage(trackingCode);
  }

  /// Parses the Correios RapidAPI response into a [PackageModel].
  PackageModel _parseCorreiosResponse(Map<String, dynamic> data) {
    final trackingCode = data['tracking_code'] as String? ?? 'unknown';
    final correiosObject = data['correios_object'] as Map<String, dynamic>?;

    if (correiosObject == null) {
      return _getMockSync(trackingCode);
    }

    final tipoPostal = correiosObject['tipoPostal'] as Map<String, dynamic>?;

    // Parse events
    final rawEvents = correiosObject['eventos'] as List<dynamic>? ?? [];
    final events = rawEvents.map((e) {
      final event = e as Map<String, dynamic>;
      final dtHr = event['dtHrCriado'] as Map<String, dynamic>?;
      DateTime? date;
      if (dtHr != null) {
        date = DateTime.tryParse(dtHr['date'] as String? ?? '');
      }

      final unidade = event['unidade'] as Map<String, dynamic>?;
      final endereco = unidade?['endereco'] as Map<String, dynamic>?;
      final unidadeDestino =
          event['unidadeDestino'] as Map<String, dynamic>?;
      final enderecoDestino =
          unidadeDestino?['endereco'] as Map<String, dynamic>?;

      return TrackingEvent(
        date: date ?? DateTime.now(),
        location: '${endereco?['cidade'] ?? ''}, ${endereco?['uf'] ?? ''}',
        description: event['descricao'] as String? ?? '',
        eventCode: event['codigo'] as String?,
        unitName: unidade?['nome'] as String?,
        unitCity: endereco?['cidade'] as String?,
        unitState: endereco?['uf'] as String?,
        destinationCity: enderecoDestino?['cidade'] as String?,
        destinationState: enderecoDestino?['uf'] as String?,
        frontEndDescription: event['descricaoFrontEnd'] as String?,
        iconPath: event['icone'] as String?,
        detail: event['detalhe'] as String?,
        comment: event['comentario'] as String?,
        isFinal: (event['finalizador'] as String?) == 'S',
      );
    }).toList();

    // Determine status from events
    String status;
    final lastFinalEvent = events.where((e) => e.isFinal).lastOrNull;
    final lastEvent = events.isNotEmpty ? events.last : null;

    if (lastFinalEvent != null) {
      status = lastFinalEvent.description;
    } else if (lastEvent != null) {
      status = lastEvent.description;
    } else {
      status = 'Registrado';
    }

    // Get origin from first event, destination from last unit
    final firstEvent = events.isNotEmpty ? events.first : null;
    final origin = firstEvent != null
        ? '${firstEvent.unitCity ?? ''}, ${firstEvent.unitState ?? ''}'
        : null;

    // Try to get destination from last event's destinationUnit
    String? destination;
    if (lastEvent?.destinationCity != null) {
      destination =
          '${lastEvent!.destinationCity}, ${lastEvent.destinationState ?? ''}';
    }

    // Parse estimated delivery date (Brazilian format dd/MM/yyyy)
    DateTime? estimatedDelivery;
    if (correiosObject['dtPrevista'] != null) {
      estimatedDelivery =
          _parseBrazilianDate(correiosObject['dtPrevista'] as String);
    }

    return PackageModel(
      code: trackingCode,
      status: status,
      description: lastEvent?.frontEndDescription ?? status,
      events: events,
      lastUpdate: events.isNotEmpty ? events.last.date : null,
      origin: origin,
      destination: destination,
      tags: const [],
      carrier: data['carrier'] as String?,
      packageType: tipoPostal?['descricao'] as String?,
      packageCategory: tipoPostal?['categoria'] as String?,
      estimatedDelivery: estimatedDelivery,
      delayed: correiosObject['atrasado'] as bool? ?? false,
      lockerDelivery: correiosObject['locker'] as bool? ?? false,
    );
  }

  /// Parses Brazilian date format "dd/MM/yyyy" to DateTime.
  DateTime? _parseBrazilianDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (e) {
      debugPrint('Failed to parse Brazilian date: $dateStr — $e');
    }
    return null;
  }

  /// Sync mock for fallback when the API response has no correios_object.
  PackageModel _getMockSync(String trackingCode) {
    return PackageModel(
      code: trackingCode,
      status: 'Registrado',
      description: 'Pacote registrado',
      lastUpdate: DateTime.now(),
      origin: 'Origem não informada',
      destination: 'Destino não informado',
      events: const [],
      tags: const [],
      carrier: 'correios',
    );
  }

  /// Returns mock data for development/testing.
  Future<PackageModel> _getMockPackage(String trackingCode) async {
    await Future.delayed(const Duration(milliseconds: 600));

    switch (trackingCode) {
      case 'BR123456789':
        return PackageModel(
          code: 'BR123456789',
          status: 'Em trânsito',
          description: 'Fones de ouvido Bluetooth',
          lastUpdate: DateTime.now().subtract(const Duration(hours: 3)),
          origin: 'São Paulo, SP',
          destination: 'Rio de Janeiro, RJ',
          carrier: 'correios',
          packageType: 'ENCOMENDA PAC',
          packageCategory: 'ETIQUETA LOGICA PAC',
          estimatedDelivery:
              DateTime.now().add(const Duration(days: 2)),
          delayed: false,
          lockerDelivery: false,
          events: [
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 5)),
              location: 'São Paulo, SP',
              description: 'Objeto postado',
              eventCode: 'PO',
              unitName: 'Agência São Paulo Central',
              unitCity: 'São Paulo',
              unitState: 'SP',
              frontEndDescription: 'Objeto postado',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 3)),
              location: 'Centro de Distribuição, SP',
              description: 'Objeto em trânsito',
              eventCode: 'RO',
              unitName: 'CDD São Paulo',
              unitCity: 'São Paulo',
              unitState: 'SP',
              frontEndDescription: 'Objeto em trânsito',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(hours: 3)),
              location: 'Unidade de Tratamento, RJ',
              description: 'Objeto em trânsito',
              eventCode: 'RO',
              unitName: 'CTE Rio de Janeiro',
              unitCity: 'Rio de Janeiro',
              unitState: 'RJ',
              destinationCity: 'Rio de Janeiro',
              destinationState: 'RJ',
              frontEndDescription: 'Objeto em trânsito',
            ),
          ],
          tags: const [],
        );

      case 'US987654321':
        return PackageModel(
          code: 'US987654321',
          status: 'Saiu para entrega',
          description: 'Teclado Mecânico',
          lastUpdate: DateTime.now().subtract(const Duration(hours: 1)),
          origin: 'Miami, FL',
          destination: 'Rio de Janeiro, RJ',
          carrier: 'correios',
          packageType: 'ENCOMENDA PAC',
          packageCategory: 'ETIQUETA LOGICA PAC',
          estimatedDelivery: DateTime.now(),
          delayed: false,
          lockerDelivery: false,
          events: [
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 7)),
              location: 'Miami, FL',
              description: 'Objeto postado',
              eventCode: 'PO',
              unitName: 'Miami Processing Center',
              unitCity: 'Miami',
              unitState: 'FL',
              frontEndDescription: 'Objeto postado',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 5)),
              location: 'Centro Internacional, SP',
              description: 'Objeto em trânsito',
              eventCode: 'RO',
              unitName: 'Centro Internacional',
              unitCity: 'São Paulo',
              unitState: 'SP',
              frontEndDescription: 'Objeto em trânsito',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 2)),
              location: 'Unidade de Distribuição, SP',
              description: 'Objeto em trânsito',
              eventCode: 'RO',
              unitName: 'CDD São Paulo',
              unitCity: 'São Paulo',
              unitState: 'SP',
              frontEndDescription: 'Objeto em trânsito',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(hours: 1)),
              location: 'Rio de Janeiro, RJ',
              description: 'Objeto saiu para entrega',
              eventCode: 'BDE',
              unitName: 'CDD Rio de Janeiro',
              unitCity: 'Rio de Janeiro',
              unitState: 'RJ',
              destinationCity: 'Rio de Janeiro',
              destinationState: 'RJ',
              frontEndDescription: 'Objeto saiu para entrega',
            ),
          ],
          tags: const [],
        );

      case 'CN555666777':
        return PackageModel(
          code: 'CN555666777',
          status: 'Entregue',
          description: 'Smart Watch',
          lastUpdate: DateTime.now().subtract(const Duration(days: 2)),
          origin: 'Shenzhen, China',
          destination: 'São Paulo, SP',
          carrier: 'correios',
          packageType: 'ENCOMENDA PAC',
          packageCategory: 'ETIQUETA LOGICA PAC',
          estimatedDelivery:
              DateTime.now().subtract(const Duration(days: 2)),
          delayed: false,
          lockerDelivery: false,
          events: [
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 14)),
              location: 'Shenzhen, China',
              description: 'Objeto postado',
              eventCode: 'PO',
              unitName: 'Shenzhen Logistics',
              unitCity: 'Shenzhen',
              frontEndDescription: 'Objeto postado',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 12)),
              location: 'Centro Internacional, SP',
              description: 'Objeto em trânsito',
              eventCode: 'RO',
              unitName: 'Centro Internacional',
              unitCity: 'São Paulo',
              unitState: 'SP',
              frontEndDescription: 'Objeto em trânsito',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 8)),
              location: 'Unidade de Distribuição, SP',
              description: 'Objeto em trânsito',
              eventCode: 'RO',
              unitName: 'CDD São Paulo',
              unitCity: 'São Paulo',
              unitState: 'SP',
              frontEndDescription: 'Objeto em trânsito',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 3)),
              location: 'São Paulo, SP',
              description: 'Objeto saiu para entrega',
              eventCode: 'BDE',
              unitName: 'CDD São Paulo',
              unitCity: 'São Paulo',
              unitState: 'SP',
              destinationCity: 'São Paulo',
              destinationState: 'SP',
              frontEndDescription: 'Objeto saiu para entrega',
            ),
            TrackingEvent(
              date: DateTime.now().subtract(const Duration(days: 2)),
              location: 'São Paulo, SP',
              description: 'Objeto entregue',
              eventCode: 'FC',
              unitName: 'CDD São Paulo',
              unitCity: 'São Paulo',
              unitState: 'SP',
              frontEndDescription: 'Objeto entregue ao destinatário',
              isFinal: true,
            ),
          ],
          tags: const [],
        );

      default:
        if (trackingCode.length >= 9) {
          return PackageModel(
            code: trackingCode,
            status: 'Registrado',
            description: 'Pacote registrado',
            lastUpdate: DateTime.now(),
            origin: 'Origem não informada',
            destination: 'Destino não informado',
            carrier: 'correios',
            events: [
              TrackingEvent(
                date: DateTime.now(),
                location: 'Origem não informada',
                description: 'Objeto postado',
                eventCode: 'PO',
                frontEndDescription: 'Objeto postado',
              ),
            ],
            tags: const [],
          );
        }
        return PackageModel(
          code: trackingCode,
          status: 'Não encontrado',
          description: 'Código de rastreio não reconhecido',
          lastUpdate: DateTime.now(),
          events: [],
          tags: const [],
        );
    }
  }
}

/// Riverpod provider for [PackageRepository].
@riverpod
PackageRepository packageRepository(PackageRepositoryRef ref) {
  final apiKey = dotenv.env['RAPIDAPI_KEY'];
  final apiHost = dotenv.env['RAPIDAPI_HOST'];
  final baseUrl = dotenv.env['RAPIDAPI_BASE_URL'] ??
      'https://correios-rastreamento-de-encomendas.p.rapidapi.com';
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  return PackageRepository(dio, apiKey, apiHost);
}
