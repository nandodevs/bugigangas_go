#!/usr/bin/env python3
"""
make_transparent.py — Remove o fundo sólido do app_icon.png

Funcionamento:
  1. Carrega assets/icons/app_icon.png
  2. Identifica a cor de fundo dominante (amostra nos cantos)
  3. Torna todos os pixels com cor ≈ fundo 100% transparentes (alpha=0)
  4. Preserva a tartaruga + círculo verde intactos
  5. Salva como assets/icons/app_icon.png (substitui o original)

Uso:
    python scripts/make_transparent.py

Pré-requisitos:
    pip install Pillow
"""

from PIL import Image
import os

ICON_PATH = os.path.join(os.path.dirname(__file__), "..", "assets", "icons", "app_icon.png")
BACKUP_PATH = os.path.join(os.path.dirname(__file__), "..", "assets", "icons", "app_icon_original.png")

TOLERANCE = 40  # Margem para variação de cor (0-255). Ajuste se necessário.


def colors_match(c1, c2, tol):
    """Verifica se dois pixels RGB estão dentro da tolerância."""
    return all(abs(c1[i] - c2[i]) <= tol for i in range(3))


def get_background_color(img):
    """Amostra os 4 cantos e retorna a cor mediana (mais frequente)."""
    w, h = img.size
    samples = [
        img.getpixel((5, 5)),
        img.getpixel((w - 5, 5)),
        img.getpixel((5, h - 5)),
        img.getpixel((w - 5, h - 5)),
        img.getpixel((w // 2, 5)),
        img.getpixel((w // 2, h - 5)),
        img.getpixel((5, h // 2)),
        img.getpixel((w - 5, h // 2)),
    ]
    # Pega a média dos cantos como cor de fundo
    r = sum(s[0] for s in samples) // len(samples)
    g = sum(s[1] for s in samples) // len(samples)
    b = sum(s[2] for s in samples) // len(samples)
    return (r, g, b)


def process():
    if not os.path.isfile(ICON_PATH):
        print(f"❌ Arquivo não encontrado: {ICON_PATH}")
        return

    # --- 1. Fazer backup ---
    if not os.path.isfile(BACKUP_PATH):
        img_orig = Image.open(ICON_PATH)
        img_orig.save(BACKUP_PATH)
        print(f"📦 Backup salvo: {BACKUP_PATH}")
    else:
        print(f"ℹ️  Backup já existe: {BACKUP_PATH}")

    # --- 2. Carregar imagem ---
    img = Image.open(ICON_PATH).convert("RGBA")
    w, h = img.size
    print(f"📐 Imagem: {w}x{h}, modo={img.mode}")

    # --- 3. Detectar cor de fundo ---
    bg = get_background_color(img)
    print(f"🎨 Cor de fundo detectada: RGB({bg[0]}, {bg[1]}, {bg[2]})")
    hex_bg = f"#{bg[0]:02x}{bg[1]:02x}{bg[2]:02x}"
    print(f"   Hex: {hex_bg}")
    print(f"   Tolerância: ±{TOLERANCE}")

    # --- 4. Criar nova imagem com fundo transparente ---
    pixels = img.load()
    transparent_count = 0
    kept_count = 0

    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if colors_match((r, g, b), bg, TOLERANCE):
                # Pixel corresponde ao fundo → transparente
                pixels[x, y] = (r, g, b, 0)
                transparent_count += 1
            else:
                kept_count += 1

    total = transparent_count + kept_count
    pct_transparent = (transparent_count / total) * 100
    print(f"\n📊 Resultado:")
    print(f"   Pixels tornados transparentes: {transparent_count} ({pct_transparent:.1f}%)")
    print(f"   Pixels preservados:            {kept_count} ({100 - pct_transparent:.1f}%)")

    # --- 5. Salvar ---
    img.save(ICON_PATH)
    print(f"\n💾 Salvo: {ICON_PATH}")
    print(f"   Tamanho: {os.path.getsize(ICON_PATH)} bytes")

    # --- 6. Verificação ---
    img2 = Image.open(ICON_PATH).convert("RGBA")
    corner_alpha = [
        img2.getpixel((5, 5))[3],
        img2.getpixel((w - 5, 5))[3],
        img2.getpixel((5, h - 5))[3],
        img2.getpixel((w - 5, h - 5))[3],
    ]
    all_transparent = all(a == 0 for a in corner_alpha)
    print(f"\n🔍 Verificação dos cantos:")
    print(f"   Alpha dos 4 cantos: {corner_alpha}")
    if all_transparent:
        print("   ✅ Cantos estão transparentes — sucesso!")
    else:
        print("   ⚠️  Alguns cantos ainda têm alpha > 0.")
        print("   Tente aumentar TOLERANCE no script (ex: 60) e execute novamente.")

    print(f"\n▶️  Próximo passo: dart run flutter_launcher_icons")


if __name__ == "__main__":
    process()
