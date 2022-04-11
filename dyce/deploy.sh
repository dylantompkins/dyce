rm -r public/*
flutter build web
cp -r build/web/* public/
firebase deploy
