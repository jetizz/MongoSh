DB_AUTHSOURCE=${DB_AUTHSOURCE:-admin}
SERVER_PORT=${SERVER_PORT:-27017}
GLOBAL_TRANSACTION=${GLOBAL_TRANSACTION:-0}
SCRIPT_HEADER_FILE=${SCRIPT_HEADER:-/var/mongosh/static/header.js}
SCRIPT_FOOTER_FILE=${SCRIPT_FOOTER:-/var/mongosh/static/footer.js}

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
echo " - GLOBAL_TRANSACTION=$GLOBAL_TRANSACTION"
echo " - SCRIPT_HEADER_FILE=$SCRIPT_HEADER_FILE"
echo " - SCRIPT_FOOTER_FILE=$SCRIPT_FOOTER_FILE"
echo "Using parameters:"
echo " - Uri=$mongouri"
echo " - Script=$script"
echo ""

append_text() {
    echo -e "$1" >> "$script"
}
append_log() {
    echo "print('$1');" >> "$script"
}
append_header_footer() {
    # param $1 = header | footer
    
    src_txt=""
    src_file=""
    if [[ "$1" == "header" ]]; then
        src_txt="$SCRIPT_HEADER"
        src_file="$SCRIPT_HEADER_FILE"
    elif [[ "$1" == "footer" ]]; then
        src_txt="$SCRIPT_FOOTER"
        src_file="$SCRIPT_FOOTER_FILE"
    fi
    
    if [ -n "$src_txt" ]; then
        append_text "// Static $1 obtained from text source"
        append_text "\n$src_txt\n"
    elif [[ -f $src_file ]]; then
        # to be safe - remove BOM
        append_text "// Static $1 obtained from text file: $src_file"
        sed '1s/^\xEF\xBB\xBF//' "$src_file" >> "$script"
    else
        append_text "// Static $1 skipped"
    fi
}
append_file() {
    dir=${1%/*}
    file=${1##*/}
    
    append_log "\nExecuting: $1..."

    append_header_footer "header"
    
    append_text "// Runtime variables: $1"
    append_text "SCRIPT_PATH=\"$dir\""
    append_text "SCRIPT_FILE=\"$file\""

    #cat "$1" >> $script
    # to be safe - remove BOM
    append_text "// File: $1"
    sed '1s/^\xEF\xBB\xBF//' "$1" >> "$script"

    append_header_footer "footer"
}
prepend_text() {
    tmp=$(mktemp)
    cat <(echo -e "$1") "$script" > "$tmp"
    mv "$tmp" "$script"
}

if [ -z "${SERVER_NAME}" ] || [ -z "${DB_NAME}" ]; then
    echo "Missing mandatory environment variables (SERVER_NAME, DB_NAME)"
else

    # Define globals used within a script
    append_text "var SCRIPT_PATH;"
    append_text "var SCRIPT_FILE;"

    if [[ "$Server_Name" == 1 ]]; then
        echo "Injecting transaction code..."
        append_text "var session = db.getMongo().startSession( { readPreference: { mode: "primary" } } );"
        append_text "session.startTransaction( { readConcern: { level: "local" }, writeConcern: { w: "majority" } } );"
        append_text "try {"
    fi

    shopt -s globstar
    for f in /var/mongosh/scripts/**; do
        if [[ -f $f ]]; then
            case "$f" in
                *.js)
                    echo "Embed: $f";
                    append_text "\n\n/**** File: $f */\n\n"
                    append_file $f
                    ((i++))
                ;;
                *)
                    echo "Ignore: $f"
                ;;
            esac
        fi
    done

    if [[ "$Server_Name" == 1 ]]; then
        append_text "} catch (error) { session.abortTransaction(); throw error; }"
        append_text "session.commitTransaction();"
        append_text "session.endSession();"
    fi


    if [[ "$i" -gt 0 ]]; then
        echo -e '\n==== Running embedded script ====\n'
        echo "Executing final script with $i embedded files."
        echo "Source: $script"
        echo ""
        mongosh "$mongouri" --quiet --username "$DB_USER" --password "$DB_PASS" --authenticationDatabase "$DB_AUTHSOURCE" --file "$script"
        echo -e '\n==== Running embedded script in transaction complete ====\n'
    else
        echo "Final script had no files embedded."
    fi
fi