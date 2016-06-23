#Yes/No Dialog - Implementar en ifs
read -p "Are you sure? " -n 1 -r choice
echo    # (optional) move to a new line
if [[ $choice =~ ^[Yy]$ ]]
then
    echo "yes!"
else
    echo "no!"    
fi
