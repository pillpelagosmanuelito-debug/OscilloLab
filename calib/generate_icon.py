"""
Genera el icono de OscilloLab: pantalla de osciloscopio (fondo grafito,
traza verde fosforo tipo seno) con una aguja de multimetro superpuesta
en ambar, siguiendo la paleta definida en lib/theme/app_theme.dart.
No reutiliza ningun icono de las apps anteriores de la fabrica.
"""
import math
from PIL import Image, ImageDraw

SIZE = 1024
GRAFITO = (18, 24, 27, 255)
GRAFITO_OSCURO = (6, 18, 10, 255)
VERDE = (57, 255, 136, 255)
AMBAR = (255, 179, 0, 255)

img = Image.new("RGBA", (SIZE, SIZE), GRAFITO)
draw = ImageDraw.Draw(img)

# Panel interior (pantalla del osciloscopio) con esquinas redondeadas
margen = 90
draw.rounded_rectangle(
    [margen, margen, SIZE - margen, SIZE - margen],
    radius=90,
    fill=GRAFITO_OSCURO,
    outline=(*VERDE[:3], 140),
    width=6,
)

# Grilla tenue
grid_color = (57, 255, 136, 40)
n_div = 6
paso = (SIZE - 2 * margen) / n_div
for i in range(1, n_div):
    x = margen + i * paso
    draw.line([(x, margen), (x, SIZE - margen)], fill=grid_color, width=2)
    y = margen + i * paso
    draw.line([(margen, y), (SIZE - margen, y)], fill=grid_color, width=2)

# Traza senoidal (osciloscopio)
puntos = []
ancho_util = SIZE - 2 * margen
centro_y = SIZE * 0.58
amplitud = SIZE * 0.16
for i in range(400):
    t = i / 399
    x = margen + t * ancho_util
    y = centro_y - amplitud * math.sin(t * 2 * math.pi * 1.6)
    puntos.append((x, y))
draw.line(puntos, fill=VERDE, width=22, joint="curve")

# Aguja de multimetro (arco + aguja), en la mitad superior del panel
cx, cy = SIZE / 2, SIZE * 0.40
radio = SIZE * 0.20
draw.arc(
    [cx - radio, cy - radio, cx + radio, cy + radio],
    start=200, end=340, fill=AMBAR, width=14,
)
angulo = math.radians(255)
punta_x = cx + radio * 0.85 * math.cos(angulo)
punta_y = cy + radio * 0.85 * math.sin(angulo)
draw.line([(cx, cy), (punta_x, punta_y)], fill=AMBAR, width=14)
draw.ellipse([cx - 16, cy - 16, cx + 16, cy + 16], fill=AMBAR)

img.save("/home/claude/build/oscillolab/assets/icon/icon.png")
print("Icono generado:", img.size)
