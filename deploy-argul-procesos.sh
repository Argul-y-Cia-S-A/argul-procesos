#!/usr/bin/env bash
# ============================================================
#  deploy-argul-procesos.sh
#  Script de deploy del Mapa de Procesos Argul → GitHub Pages
#  Organización: https://github.com/Argul-y-Cia-S-A
#  Ejecutar una sola vez para el setup inicial.
# ============================================================

set -e   # Detener si hay error en cualquier paso

# ── CONFIG ──────────────────────────────────────────────────
REPO_NAME="argul-procesos"
ORG="Argul-y-Cia-S-A"
REMOTE_URL="https://github.com/${ORG}/${REPO_NAME}.git"

# Carpeta donde están los archivos FP en tu máquina.
# ⚠️  AJUSTÁ esta ruta antes de ejecutar el script.
ORIGEN="$HOME/Downloads/argul-flujos"

# Carpeta de trabajo (se crea sola)
DESTINO="$HOME/repos/${REPO_NAME}"
# ────────────────────────────────────────────────────────────

echo ""
echo "╔═══════════════════════════════════════════════════════╗"
echo "║  Argul — Deploy Mapa de Procesos → GitHub Pages       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# ── PASO 1: Verificar Git ────────────────────────────────────
echo "▶ PASO 1 — Verificando Git..."
if ! command -v git &>/dev/null; then
  echo "  ✗ Git no está instalado. Instalalo desde https://git-scm.com"
  exit 1
fi
echo "  ✓ Git $(git --version | awk '{print $3}')"

# ── PASO 2: Crear carpeta local ──────────────────────────────
echo ""
echo "▶ PASO 2 — Creando carpeta local: $DESTINO"
mkdir -p "$DESTINO"
echo "  ✓ Carpeta creada"

# ── PASO 3: Copiar archivos FP ───────────────────────────────
echo ""
echo "▶ PASO 3 — Copiando archivos FP desde: $ORIGEN"

ARCHIVOS=(
  "20260430_Ventas_FP_v3_0.html"
  "20260430_Planificacion_FP_v4_0.html"
  "20260430_Compras_FP_v3_0.html"
  "20260430_Produccion_FP_v5_0.html"
  "20260430_Calidad_FP_v5_0.html"
  "20260430_Inventario_WMS_FP_v3_0.html"
  "20260430_Ingenieria_FP_v3_0.html"
  "20260430_Matriceria_FP_v4_0.html"
  "20260430_Contabilidad_Adm_Finanzas_FP_v5_0.html"
  "20260430_COMEX_FP_v1_0.html"
)

FALTANTES=0
for f in "${ARCHIVOS[@]}"; do
  if [ -f "$ORIGEN/$f" ]; then
    cp "$ORIGEN/$f" "$DESTINO/"
    echo "  ✓ $f"
  else
    echo "  ✗ NO ENCONTRADO: $f"
    FALTANTES=$((FALTANTES+1))
  fi
done

# Copiar index.html (es el Mapa de Procesos Nivel 1, renombrado)
if [ -f "$ORIGEN/index.html" ]; then
  cp "$ORIGEN/index.html" "$DESTINO/"
  echo "  ✓ index.html (Mapa de Procesos Nivel 1)"
else
  echo "  ✗ NO ENCONTRADO: index.html — copialo manualmente a $DESTINO"
  FALTANTES=$((FALTANTES+1))
fi

if [ "$FALTANTES" -gt 0 ]; then
  echo ""
  echo "  ⚠ Faltan $FALTANTES archivo(s). Continuando de todos modos..."
fi

# ── PASO 4: Inicializar Git ──────────────────────────────────
echo ""
echo "▶ PASO 4 — Inicializando repositorio Git..."
cd "$DESTINO"

if [ -d ".git" ]; then
  echo "  ℹ Repositorio Git ya existe, salteando git init"
else
  git init
  echo "  ✓ git init"
fi

# ── PASO 5: Crear README ─────────────────────────────────────
echo ""
echo "▶ PASO 5 — Creando README.md..."
cat > README.md << 'READMEEOF'
# Argul y Compañía S.A. — Mapa de Procesos

Plataforma de flujos de procesos del proyecto de migración SAP → Odoo 17 Enterprise.

**Go Live objetivo:** 1 de junio de 2026  
**Alcance Etapa 1:** Ventas · Planificación · Compras · Producción · Calidad · Inventario/WMS · Ingeniería · Matricería · Contabilidad/Adm./Finanzas · COMEX

## Acceso

→ **[Ver mapa de procesos](https://Argul-y-Cia-S-A.github.io/argul-procesos/)**

## Archivos

| Área | Archivo | Versión |
|---|---|---|
| Mapa de Procesos (Nivel 1) | index.html | v1.0 |
| Ventas | 20260430_Ventas_FP_v3_0.html | v3.0 |
| Planificación | 20260430_Planificacion_FP_v4_0.html | v4.0 |
| Compras | 20260430_Compras_FP_v3_0.html | v3.0 |
| Producción | 20260430_Produccion_FP_v5_0.html | v5.0 |
| Calidad | 20260430_Calidad_FP_v5_0.html | v5.0 |
| Inventario / WMS | 20260430_Inventario_WMS_FP_v3_0.html | v3.0 |
| Ingeniería | 20260430_Ingenieria_FP_v3_0.html | v3.0 |
| Matricería | 20260430_Matriceria_FP_v4_0.html | v4.0 |
| Contabilidad / Adm. / Finanzas | 20260430_Contabilidad_Adm_Finanzas_FP_v5_0.html | v5.0 |
| COMEX | 20260430_COMEX_FP_v1_0.html | v1.0 |
READMEEOF
echo "  ✓ README.md"

# ── PASO 6: Crear .gitignore ─────────────────────────────────
echo ""
echo "▶ PASO 6 — Creando .gitignore..."
cat > .gitignore << 'GITEOF'
.DS_Store
Thumbs.db
*.bak
*.tmp
GITEOF
echo "  ✓ .gitignore"

# ── PASO 7: Primer commit ────────────────────────────────────
echo ""
echo "▶ PASO 7 — Staging y primer commit..."
git add .
git status --short
git commit -m "feat: deploy inicial — index.html (Nivel 1) + 10 flujos de procesos Argul"
echo "  ✓ Commit creado"

# ── PASO 8: Branch main y remote ────────────────────────────
echo ""
echo "▶ PASO 8 — Configurando branch main y remote origin..."
git branch -M main

# Verificar si ya existe el remote
if git remote get-url origin &>/dev/null; then
  echo "  ℹ Remote 'origin' ya existe. Verificá que apunte a: $REMOTE_URL"
  git remote set-url origin "$REMOTE_URL"
  echo "  ✓ Remote actualizado: $REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
  echo "  ✓ Remote agregado: $REMOTE_URL"
fi

# ── PASO 9: Push ─────────────────────────────────────────────
echo ""
echo "▶ PASO 9 — Pusheando a GitHub..."
echo "  (Si te pide credenciales, usá tu token de acceso personal GitHub)"
echo ""
git push -u origin main
echo "  ✓ Push exitoso"

# ── PASO 10: Instrucciones GitHub Pages ──────────────────────
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  ✓ DEPLOY COMPLETO                                            ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║                                                               ║"
echo "║  ÚLTIMO PASO MANUAL — Activar GitHub Pages:                  ║"
echo "║                                                               ║"
echo "║  1. Ir a:                                                     ║"
echo "║     https://github.com/Argul-y-Cia-S-A/argul-procesos        ║"
echo "║  2. Settings → Pages                                          ║"
echo "║  3. Source: Deploy from a branch                              ║"
echo "║  4. Branch: main / / (root)                                   ║"
echo "║  5. Save                                                      ║"
echo "║                                                               ║"
echo "║  URL del sitio (disponible en ~60 segundos):                  ║"
echo "║  https://argul-y-cia-s-a.github.io/argul-procesos/           ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
