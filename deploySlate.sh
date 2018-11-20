echo "copying index.html.md"
sudo cp /var/www/mondb/index.html.md source/
echo "building the html page"
sudo ./deploy.sh
echo "copying built content to /var/www/mondb/slate/ directory"
sudo cp -R ./build/* /var/www/mondb/slate/
echo "done !"
