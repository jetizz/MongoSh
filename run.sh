DB_AUTHSOURCE=$($DB_AUTHSOURCE:admin)
SERVER_PORT=$($SERVER_PORT:27017)

script="/tmp/__full__.js"
i=0
mongouri="mongodb://$SERVER_NAME:$SERVER_PORT/$DB_NAME"

echo "Output: $script"
if [ -f "$script" ] ; then
    rm "$script"
fi
touch $script

echo "Using environment variables:"
echo " - SERVER_NAME=$SERVER_NAME"
echo " - SERVER_PORT=$SERVER_PORT"
echo " - DB_NAME=$DB_NAME"
echo " - DB_USER=$DB_USER"
echo " - DB_PASS=$DB_PASS"
echo " - DB_AUTHSOURCE=$DB_AUTHSOURCE"
echo "Using parameters:"
echo " - Uri=$mongouri"
echo " - Script=$script"
echo ""

if [ -z "${SERVER_NAME}" ] || [ -z "${DB_NAME}" ]; then
    echo "Missing mandatory environment variables (SERVER_NAME, DB_NAME)"
else
    shopt -s globstar
    for f in /opt/init/**; do
        if [[ -f $f ]]; then
            case "$f" in
                *.js)
                        echo "Embed: $f";
                        cat "$f" >> "$script"
                        echo "$(printf "\n\n/**** File: $f */\n\n")" >> "$script"
                        ((i++))
                ;;
                *)
                        echo "Ignore: $f"
                ;;
            esac
        fi
    done


    if [[ "$i" -gt 0 ]]; then
        echo "Executing final script with $i embedded files."
        echo "Source: $out"
        echo ""
        mongosh "$mongouri" --username "$DB_USER" --password "$DB_PASS" --authenticationDatabase "$DB_AUTHSOURCE" --file "$script"
    else
        echo "Final script had no files embedded."
    fi
fi