#!/usr/bin/env python3
"""
analyze_icon.py — Analisa o app_icon.png do Bugigangas GO

Uso:
    python scripts/analyze_icon.py

O que faz:
    1. Carrega assets/icons/app_icon.png com Pillow
    2. Verifica se tem canal alpha (transparência)
    3. Amostra pixels nos cantos e bordas para detectar cor de fundo
    4. Reporta se o fundo é sólido ou transparente
"""

from PIL import Image
import os

ICON_PATH = os.path.join(os.path.dirname(__file__), "..", "assets", "icons", "app_icon.png")

def analyze():
    if not os.path.isfile(ICON_PATH):
        print(f"❌ Arquivo não encontrado: {ICON_PATH}")
        return

    img = Image.open(ICON_PATH)
    print(f"✅ Arquivo lido com sucesso: {ICON_PATH}")
    print(f"   Formato : {img.format}")
    print(f"   Tamanho : {img.size[0]} x {img.size[1]} px")
    print(f"   Modo    : {img.mode}")

    # --- Verificar canal alpha ---
    has_alpha = img.mode in ("RGBA", "LA", "PA") or "A" in img.mode
    print(f"   Alpha   : {'✅ SIM (já tem transparência)' if has_alpha else '❌ NÃO (RGB sólido)'}")

    # --- Converter para RGBA se não tiver alpha ---
    if not has_alpha:
        img = img.convert("RGBA")

    # --- Amostrar pixels dos 4 cantos (5x5 médio) ---
    w, h = img.size
    corners = {
        "canto-superior-esquerdo": (5, 5),
        "canto-superior-direito":  (w - 5, 5),
        "canto-inferior-esquerdo": (5, h - 5),
        "canto-inferior-direito":  (w - 5, h - 5),
    }

    print("\n--- Amostragem de pixels nos cantos (RGB) ---")
    corner_colors = []
    for name, (x, y) in corners.items():
        px = img.getpixel((x, y))
        rgba = px[:4]  # R, G, B, A
        corner_colors.append(rgba)
        alpha_status = f"alpha={rgba[3]}" if has_alpha or img.mode == "RGBA" else "sem alpha"
        print(f"   {name:30s}: ({rgba[0]:3d}, {rgba[1]:3d}, {rgba[2]:3d})  {alpha_status}")

    # --- Amostrar pixels no meio das 4 bordas ---
    print("\n--- Amostragem nas bordas (centro de cada lado) ---")
    edges = {
        "borda-superior":    (w // 2, 5),
        "borda-inferior":    (w // 2, h - 5),
        "borda-esquerda":    (5, h // 2),
        "borda-direita":     (w - 5, h // 2),
    }
    for name, (x, y) in edges.items():
        px = img.getpixel((x, y))
        print(f"   {name:20s}: ({px[0]:3d}, {px[1]:3d}, {px[2]:3d})  alpha={px[3]}")

    # --- Verificar se todos os cantos são iguais (cor sólida de fundo) ---
    all_same = all(c == corner_colors[0] for c in corner_colors)
    print(f"\n--- Conclusão ---")
    if not has_alpha and all_same:
        print("🔴 FUNDO SÓLIDO (sem transparência): o PNG tem fundo opaco.")
        print(f"   Cor dominante: RGB({corner_colors[0][0]}, {corner_colors[0][1]}, {corner_colors[0][2]})")
        hex_color = "#{:02x}{:02x}{:02x}".format(corner_colors[0][0], corner_colors[0][1], corner_colors[0][2])
        print(f"   Hex: {hex_color}")
        print("\n💡 Recomendação: executar scripts/make_transparent.py para remover o fundo.")
    elif not has_alpha and not all_same:
        print("⚠️  Sem alpha, mas cantos têm cores diferentes — o fundo não é uniforme.")
        print("   Pode ser uma imagem com bordas arredondadas ou gradiente.")
    elif has_alpha:
        print("🟢 JÁ TEM TRANSPARÊNCIA: o PNG já possui canal alpha.")
        print("   Verifique se os pixels do fundo estão com alpha=0.")
        transparent_corners = all(c[3] == 0 for c in corner_colors)
        if transparent_corners:
            print("   ✅ Cantos têm alpha=0 — fundo já transparente!")
        else:
            print("   ⚠️  Alguns cantos NÃO estão transparentes.")
    print()

    # --- Comparar com a cor do adaptive_icon_background ---
    print(f"--- Comparação com adaptive_icon_background (#009696) ---")
    teal = (0, 150, 150)
    if not has_alpha:
        match = all(c[:3] == teal for c in corner_colors)
        if match:
            print("✅ CORRESPONDE: O fundo do PNG é exatamente #009696 (teal).")
            print("   Isso significa que adaptive_icon_background e o fundo do PNG são idênticos.")
            print("   → O foreground cobre completamente o background no adaptive icon,")
            print("     anulando o propósito do adaptive_icon_background.")
        else:
            print(f"⏳ Diferença: cantos são RGB{corner_colors[0][:3]}, não teal (0,150,150).")

if __name__ == "__main__":
    analyze()
