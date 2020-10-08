mv docs docs_old

cd example

flutter build web

cd ..

mv example/build/web ./docs

mv docs_old/CNAME docs/

rm -rf docs_old
