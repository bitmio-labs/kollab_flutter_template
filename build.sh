rm -rf docs

cd example

flutter build web

mv build/web ../docs
