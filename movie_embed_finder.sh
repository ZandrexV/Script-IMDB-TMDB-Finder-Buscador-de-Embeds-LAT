#!/data/data/com.termux/files/usr/bin/bash

# Script para buscar IDs de TMDB e IMDB y generar enlaces embed
# Uso: ./movie_embed_finder.sh "nombre de la película"

# Colores para el output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # Sin color

# API Key de TMDB (necesitas conseguir una gratis en https://www.themoviedb.org/settings/api)
# Reemplaza 'TU_API_KEY' con tu clave real
TMDB_API_KEY="TU_API_KEY"

# Función para mostrar uso
show_usage() {
    echo -e "${YELLOW}Uso:${NC} $0 \"nombre de la película\""
    echo -e "${YELLOW}Ejemplo:${NC} $0 \"The Matrix\""
    exit 1
}

# Verificar que se pasó un argumento
if [ -z "$1" ]; then
    echo -e "${RED}Error: Debes proporcionar el nombre de una película${NC}"
    show_usage
fi

# Verificar que la API key está configurada
if [ "$TMDB_API_KEY" = "TU_API_KEY" ]; then
    echo -e "${RED}Error: Debes configurar tu API key de TMDB${NC}"
    echo -e "${YELLOW}Pasos:${NC}"
    echo "1. Ve a https://www.themoviedb.org/signup"
    echo "2. Crea una cuenta gratuita"
    echo "3. Ve a https://www.themoviedb.org/settings/api"
    echo "4. Solicita una API key (elige 'Developer')"
    echo "5. Edita este script y reemplaza 'TU_API_KEY' con tu clave"
    exit 1
fi

# Verificar que curl está instalado
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl no está instalado${NC}"
    echo -e "${YELLOW}Instálalo con:${NC} pkg install curl"
    exit 1
fi

# Verificar que jq está instalado
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq no está instalado${NC}"
    echo -e "${YELLOW}Instálalo con:${NC} pkg install jq"
    exit 1
fi

MOVIE_NAME="$1"
echo -e "${BLUE}Buscando información para: ${GREEN}$MOVIE_NAME${NC}\n"

# Codificar el nombre de la película para URL
ENCODED_NAME=$(echo "$MOVIE_NAME" | sed 's/ /%20/g')

# Hacer la búsqueda en TMDB
SEARCH_URL="https://api.themoviedb.org/3/search/movie?api_key=$TMDB_API_KEY&query=$ENCODED_NAME&language=es-ES"

# Obtener resultados
RESULTS=$(curl -s "$SEARCH_URL")

# Verificar si hubo error
if echo "$RESULTS" | jq -e '.success == false' > /dev/null 2>&1; then
    echo -e "${RED}Error en la API:${NC}"
    echo "$RESULTS" | jq -r '.status_message'
    exit 1
fi

# Contar resultados
TOTAL_RESULTS=$(echo "$RESULTS" | jq -r '.total_results')

if [ "$TOTAL_RESULTS" -eq 0 ]; then
    echo -e "${RED}No se encontraron resultados para: $MOVIE_NAME${NC}"
    exit 1
fi

echo -e "${GREEN}Se encontraron $TOTAL_RESULTS resultados:${NC}\n"

# Mostrar los primeros 5 resultados
echo "$RESULTS" | jq -r '.results[0:5] | to_entries[] | 
    "\(.key + 1). \(.value.title) (\(.value.release_date[0:4] // "N/A"))"'

echo ""
echo -e "${YELLOW}Selecciona el número de la película (1-5) o presiona Enter para la primera:${NC}"
read -r SELECTION

# Si no se selecciona nada, usar la primera
if [ -z "$SELECTION" ]; then
    SELECTION=1
fi

# Validar selección
if ! [[ "$SELECTION" =~ ^[1-5]$ ]]; then
    echo -e "${RED}Selección inválida${NC}"
    exit 1
fi

# Ajustar índice (array empieza en 0)
INDEX=$((SELECTION - 1))

# Obtener información de la película seleccionada
TMDB_ID=$(echo "$RESULTS" | jq -r ".results[$INDEX].id")
TITLE=$(echo "$RESULTS" | jq -r ".results[$INDEX].title")
ORIGINAL_TITLE=$(echo "$RESULTS" | jq -r ".results[$INDEX].original_title")
RELEASE_DATE=$(echo "$RESULTS" | jq -r ".results[$INDEX].release_date")
OVERVIEW=$(echo "$RESULTS" | jq -r ".results[$INDEX].overview")

# Obtener detalles adicionales incluyendo IMDB ID
DETAILS_URL="https://api.themoviedb.org/3/movie/$TMDB_ID?api_key=$TMDB_API_KEY&language=es-ES"
DETAILS=$(curl -s "$DETAILS_URL")

IMDB_ID=$(echo "$DETAILS" | jq -r '.imdb_id')
RUNTIME=$(echo "$DETAILS" | jq -r '.runtime')
VOTE_AVERAGE=$(echo "$DETAILS" | jq -r '.vote_average')

# Generar enlaces embed
UNLIMPLAY_EMBED="https://unlimplay.com/play/embed/movie/$TMDB_ID"
VERHDLINK_EMBED="https://verhdlink.cam/movie/$IMDB_ID"

# Mostrar resultados
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${MAGENTA}📽️  INFORMACIÓN DE LA PELÍCULA${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}Título:${NC} $TITLE"
if [ "$ORIGINAL_TITLE" != "$TITLE" ]; then
    echo -e "${BLUE}Título original:${NC} $ORIGINAL_TITLE"
fi
echo -e "${BLUE}Año:${NC} ${RELEASE_DATE:0:4}"
if [ "$RUNTIME" != "null" ] && [ -n "$RUNTIME" ]; then
    echo -e "${BLUE}Duración:${NC} $RUNTIME minutos"
fi
if [ "$VOTE_AVERAGE" != "null" ] && [ -n "$VOTE_AVERAGE" ]; then
    echo -e "${BLUE}Calificación:${NC} $VOTE_AVERAGE/10"
fi
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}🔑 IDs:${NC}"
echo -e "${BLUE}TMDB ID:${NC} ${GREEN}$TMDB_ID${NC}"
if [ "$IMDB_ID" != "null" ] && [ -n "$IMDB_ID" ]; then
    echo -e "${BLUE}IMDB ID:${NC} ${GREEN}$IMDB_ID${NC}"
else
    echo -e "${BLUE}IMDB ID:${NC} ${RED}No disponible${NC}"
fi
echo ""

echo -e "${CYAN}🌐 URLs Oficiales:${NC}"
echo -e "${BLUE}TMDB:${NC} https://www.themoviedb.org/movie/$TMDB_ID"
if [ "$IMDB_ID" != "null" ] && [ -n "$IMDB_ID" ]; then
    echo -e "${BLUE}IMDB:${NC} https://www.imdb.com/title/$IMDB_ID"
fi
echo ""

echo -e "${MAGENTA}🎬 ENLACES EMBED:${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${CYAN}Unlimplay:${NC}"
echo -e "${YELLOW}$UNLIMPLAY_EMBED${NC}"
echo ""
if [ "$IMDB_ID" != "null" ] && [ -n "$IMDB_ID" ]; then
    echo -e "${CYAN}Verhdlink:${NC}"
    echo -e "${YELLOW}$VERHDLINK_EMBED${NC}"
else
    echo -e "${CYAN}Verhdlink:${NC}"
    echo -e "${RED}No disponible (requiere IMDB ID)${NC}"
fi
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""

if [ -n "$OVERVIEW" ] && [ "$OVERVIEW" != "null" ]; then
    echo -e "${BLUE}📝 Sinopsis:${NC}"
    echo "$OVERVIEW"
    echo ""
fi

# Opción para copiar enlaces al portapapeles (si termux-clipboard está disponible)
if command -v termux-clipboard-set &> /dev/null; then
    echo -e "${YELLOW}¿Deseas copiar los enlaces embed al portapapeles?${NC}"
    echo "1. Unlimplay"
    echo "2. Verhdlink"
    echo "3. Ambos"
    echo "4. No copiar"
    read -r COPY_OPTION
    
    case $COPY_OPTION in
        1)
            echo "$UNLIMPLAY_EMBED" | termux-clipboard-set
            echo -e "${GREEN}✓ Enlace de Unlimplay copiado al portapapeles${NC}"
            ;;
        2)
            if [ "$IMDB_ID" != "null" ] && [ -n "$IMDB_ID" ]; then
                echo "$VERHDLINK_EMBED" | termux-clipboard-set
                echo -e "${GREEN}✓ Enlace de Verhdlink copiado al portapapeles${NC}"
            else
                echo -e "${RED}✗ No hay IMDB ID disponible${NC}"
            fi
            ;;
        3)
            if [ "$IMDB_ID" != "null" ] && [ -n "$IMDB_ID" ]; then
                echo -e "$UNLIMPLAY_EMBED\n$VERHDLINK_EMBED" | termux-clipboard-set
                echo -e "${GREEN}✓ Ambos enlaces copiados al portapapeles${NC}"
            else
                echo "$UNLIMPLAY_EMBED" | termux-clipboard-set
                echo -e "${GREEN}✓ Solo Unlimplay copiado (Verhdlink no disponible)${NC}"
            fi
            ;;
        *)
            echo -e "${BLUE}No se copió nada${NC}"
            ;;
    esac
    echo ""
fi

# Opción para guardar en archivo
echo -e "${YELLOW}¿Deseas guardar esta información en un archivo? (s/n)${NC}"
read -r SAVE_OPTION

if [ "$SAVE_OPTION" = "s" ] || [ "$SAVE_OPTION" = "S" ]; then
    # Crear nombre de archivo seguro
    SAFE_TITLE=$(echo "$TITLE" | sed 's/[^a-zA-Z0-9]/_/g')
    OUTPUT_FILE="${SAFE_TITLE}_embed_links.txt"
    
    {
        echo "=========================================="
        echo "INFORMACIÓN DE LA PELÍCULA"
        echo "=========================================="
        echo "Título: $TITLE"
        if [ "$ORIGINAL_TITLE" != "$TITLE" ]; then
            echo "Título original: $ORIGINAL_TITLE"
        fi
        echo "Año: ${RELEASE_DATE:0:4}"
        if [ "$RUNTIME" != "null" ] && [ -n "$RUNTIME" ]; then
            echo "Duración: $RUNTIME minutos"
        fi
        if [ "$VOTE_AVERAGE" != "null" ] && [ -n "$VOTE_AVERAGE" ]; then
            echo "Calificación: $VOTE_AVERAGE/10"
        fi
        echo ""
        echo "=========================================="
        echo "IDs"
        echo "=========================================="
        echo "TMDB ID: $TMDB_ID"
        if [ "$IMDB_ID" != "null" ] && [ -n "$IMDB_ID" ]; then
            echo "IMDB ID: $IMDB_ID"
        fi
        echo ""
        echo "=========================================="
        echo "ENLACES EMBED"
        echo "=========================================="
        echo "Unlimplay:"
        echo "$UNLIMPLAY_EMBED"
        echo ""
        if [ "$IMDB_ID" != "null" ] && [ -n "$IMDB_ID" ]; then
            echo "Verhdlink:"
            echo "$VERHDLINK_EMBED"
        fi
        echo ""
        echo "=========================================="
        echo "URLs Oficiales"
        echo "=========================================="
        echo "TMDB: https://www.themoviedb.org/movie/$TMDB_ID"
        if [ "$IMDB_ID" != "null" ] && [ -n "$IMDB_ID" ]; then
            echo "IMDB: https://www.imdb.com/title/$IMDB_ID"
        fi
        if [ -n "$OVERVIEW" ] && [ "$OVERVIEW" != "null" ]; then
            echo ""
            echo "=========================================="
            echo "Sinopsis"
            echo "=========================================="
            echo "$OVERVIEW"
        fi
    } > "$OUTPUT_FILE"
    
    echo -e "${GREEN}✓ Información guardada en: ${CYAN}$OUTPUT_FILE${NC}"
fi

echo ""
echo -e "${BLUE}💡 Tip:${NC} Puedes usar estos enlaces embed en tu sitio web o aplicación"
