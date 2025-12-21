# Movie Embed Finder para Termux

Script completo para buscar películas y obtener IDs de TMDB e IMDB, además de generar automáticamente enlaces embed listos para usar.

## 📋 Requisitos

```bash
pkg update
pkg install curl jq
```

**Opcional** (para copiar al portapapeles):
```bash
pkg install termux-api
```

## 🔑 Configuración de API Key

1. Ve a https://www.themoviedb.org/signup
2. Crea una cuenta gratuita
3. Ve a https://www.themoviedb.org/settings/api
4. Solicita una API key (selecciona "Developer")
5. Copia tu API key
6. Edita el script:

```bash
nano movie_embed_finder.sh
```

Reemplaza esta línea:
```bash
TMDB_API_KEY="TU_API_KEY"
```

Guarda con `Ctrl + X`, luego `Y`, luego `Enter`

## 📥 Instalación

```bash
# Dar permisos de ejecución
chmod +x movie_embed_finder.sh

# (Opcional) Moverlo a un directorio en el PATH
mv movie_embed_finder.sh ~/bin/
```

## 🚀 Uso

```bash
./movie_embed_finder.sh "nombre de la película"
```

### Ejemplos:
```bash
./movie_embed_finder.sh "The Matrix"
./movie_embed_finder.sh "Avengers Endgame"
./movie_embed_finder.sh "El Padrino"
./movie_embed_finder.sh "Inception"
```

## 💡 Características

✅ **Búsqueda de películas** por nombre
✅ **IDs automáticos** de TMDB e IMDB
✅ **Enlaces embed generados** automáticamente:
   - Unlimplay: `https://unlimplay.com/play/embed/movie/{TMDB_ID}`
   - Vimeus: `https://vimeus.com/e/movie?tmdb={TMDB_ID}&view_key=...`
   - Verhdlink: `https://verhdlink.cam/movie/{IMDB_ID}`
   - Embed69: `https://embed69.org/f/{IMDB_ID}`
✅ **Información completa**: año, duración, calificación, sinopsis
✅ **Copiar al portapapeles** (con termux-api)
✅ **Guardar en archivo** de texto
✅ **Interfaz colorida** y fácil de usar
✅ **Selección múltiple** si hay varios resultados

## 📖 Ejemplo de salida

```
Buscando información para: The Matrix

Se encontraron 4 resultados:

1. Matrix (1999)
2. The Matrix Reloaded (2003)
3. The Matrix Revolutions (2003)
4. The Matrix Resurrections (2021)

Selecciona el número de la película (1-5) o presiona Enter para la primera: 1

═══════════════════════════════════════════════
📽️  INFORMACIÓN DE LA PELÍCULA
═══════════════════════════════════════════════
Título: Matrix
Título original: The Matrix
Año: 1999
Duración: 136 minutos
Calificación: 8.7/10
═══════════════════════════════════════════════

🔑 IDs:
TMDB ID: 603
IMDB ID: tt0133093

🌐 URLs Oficiales:
TMDB: https://www.themoviedb.org/movie/603
IMDB: https://www.imdb.com/title/tt0133093

🎬 ENLACES EMBED:
═══════════════════════════════════════════════
1. Unlimplay (TMDB):
https://unlimplay.com/play/embed/movie/603

2. Vimeus (TMDB):
https://vimeus.com/e/movie?tmdb=603&view_key=mIO3kPK2Jk3hiOdw1bzXPDYYWvf-IgblslyRhziDhw

3. Verhdlink (IMDB):
https://verhdlink.cam/movie/tt0133093

4. Embed69 (IMDB):
https://embed69.org/f/tt0133093
═══════════════════════════════════════════════

📝 Sinopsis:
Thomas Anderson lleva una doble vida...

¿Deseas copiar enlaces embed al portapapeles?
1. Unlimplay (TMDB)
2. Vimeus (TMDB)
3. Verhdlink (IMDB)
4. Embed69 (IMDB)
5. Todos los enlaces (TMDB)
6. Todos los enlaces (IMDB)
7. Todos los enlaces (TMDB + IMDB)
8. No copiar
```

## 🎯 Enlaces Embed Generados

El script genera automáticamente cuatro tipos de enlaces embed:

### 1. Unlimplay (usa TMDB ID)
```
https://unlimplay.com/play/embed/movie/{TMDB_ID}
```
**Ejemplo:** `https://unlimplay.com/play/embed/movie/603`

### 2. Vimeus (usa TMDB ID)
```
https://vimeus.com/e/movie?tmdb={TMDB_ID}&view_key=mIO3kPK2Jk3hiOdw1bzXPDYYWvf-IgblslyRhziDhw
```
**Ejemplo:** `https://vimeus.com/e/movie?tmdb=603&view_key=mIO3kPK2Jk3hiOdw1bzXPDYYWvf-IgblslyRhziDhw`

### 3. Verhdlink (usa IMDB ID)
```
https://verhdlink.cam/movie/{IMDB_ID}
```
**Ejemplo:** `https://verhdlink.cam/movie/tt0133093`

### 4. Embed69 (usa IMDB ID)
```
https://embed69.org/f/{IMDB_ID}
```
**Ejemplo:** `https://embed69.org/f/tt0133093`

**Nota:** Los enlaces de Verhdlink y Embed69 solo estarán disponibles si la película tiene IMDB ID.

## 📋 Características adicionales

### Copiar al portapapeles
Si tienes `termux-api` instalado, el script te preguntará si quieres copiar los enlaces:
- Opción 1: Solo Unlimplay (TMDB)
- Opción 2: Solo Vimeus (TMDB)
- Opción 3: Solo Verhdlink (IMDB)
- Opción 4: Solo Embed69 (IMDB)
- Opción 5: Todos los enlaces TMDB
- Opción 6: Todos los enlaces IMDB
- Opción 7: Todos los enlaces (TMDB + IMDB)
- Opción 8: No copiar

### Guardar en archivo
El script puede guardar toda la información en un archivo de texto:
- IDs de TMDB e IMDB
- Enlaces embed completos
- Información de la película
- URLs oficiales
- Sinopsis

Formato del archivo: `{Titulo_Pelicula}_embed_links.txt`

## 🔧 Solución de problemas

**Error: curl no está instalado**
```bash
pkg install curl
```

**Error: jq no está instalado**
```bash
pkg install jq
```

**Error: Debes configurar tu API key**
- Verifica que hayas reemplazado `TU_API_KEY` con tu clave real

**No se encuentra IMDB ID**
- Algunas películas no tienen IMDB ID en TMDB
- Los enlaces de Verhdlink y Embed69 no estarán disponibles en estos casos
- Los enlaces de Unlimplay y Vimeus siempre funcionarán (usan TMDB ID)

**No se encuentran resultados**
- Verifica la ortografía
- Prueba con el título original en inglés
- Usa títulos más específicos

## 🎨 Uso en sitios web

Puedes usar los enlaces embed generados en tu HTML:

```html
<!-- Unlimplay (TMDB) -->
<iframe src="https://unlimplay.com/play/embed/movie/603" 
        width="100%" 
        height="500" 
        frameborder="0" 
        allowfullscreen>
</iframe>

<!-- Vimeus (TMDB) -->
<iframe src="https://vimeus.com/e/movie?tmdb=603&view_key=mIO3kPK2Jk3hiOdw1bzXPDYYWvf-IgblslyRhziDhw" 
        width="100%" 
        height="500" 
        frameborder="0" 
        allowfullscreen>
</iframe>

<!-- Verhdlink (IMDB) -->
<iframe src="https://verhdlink.cam/movie/tt0133093" 
        width="100%" 
        height="500" 
        frameborder="0" 
        allowfullscreen>
</iframe>

<!-- Embed69 (IMDB) -->
<iframe src="https://embed69.org/f/tt0133093" 
        width="100%" 
        height="500" 
        frameborder="0" 
        allowfullscreen>
</iframe>
```

## 💻 Uso avanzado

### Búsqueda por lote
Buscar múltiples películas de una lista:
```bash
while IFS= read -r movie; do
    ./movie_embed_finder.sh "$movie"
    echo "---"
done < peliculas.txt
```

### Extraer solo los enlaces
```bash
./movie_embed_finder.sh "The Matrix" | grep -A1 "ENLACES EMBED"
```

### Guardar siempre automáticamente
Modifica el script y cambia:
```bash
SAVE_OPTION="s"  # Siempre guardar
```

## 📝 Notas importantes

- La API de TMDB es gratuita con límite de 40 requests/segundo
- Los enlaces embed son de servicios de terceros
- Respeta los derechos de autor y términos de servicio
- Este script es solo para fines informativos

## 🆘 Ayuda rápida

```bash
# Ver ayuda
./movie_embed_finder.sh

# Buscar película (siempre usa comillas)
./movie_embed_finder.sh "nombre de película"

# Si no recuerdas el nombre exacto, busca algo general
./movie_embed_finder.sh "matrix"
```

## 🔗 Enlaces útiles

- TMDB API Docs: https://developers.themoviedb.org/3
- Conseguir API Key: https://www.themoviedb.org/settings/api
- Termux API: https://wiki.termux.com/wiki/Termux:API

---

**¿Necesitas ayuda?** Revisa que:
1. ✅ Instalaste curl y jq
2. ✅ Configuraste tu API key correctamente
3. ✅ Usas comillas en el nombre de la película
4. ✅ Tienes conexión a internet
