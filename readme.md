# Mongo-based image with script auto-execution

Mount all scripts into `var/mongosh/scripts/`.
Set environment variables:

```sh
# mongo address
SERVER_NAME

# mongo port, optional, default: 27017
SERVER_PORT

# database name, required
DB_NAME

# username, optional
DB_USER

# password, optional
DB_PASS

# auth source, optional, default: admin
DB_AUTHSOURCE

# 0 = no transaction code injected
# 1 = wrap combined script into transaction
# 2 = wrap individual scripts into transactions -- not supported
GLOBAL_TRANSACTION

# Prepended to each script file. Ignored if empty.
SCRIPT_HEADER
# Prepended to each script file. Ignored if SCRIPT_HEADER is set or empty.
# Default value: /var/mongosh/static/header.js
SCRIPT_HEADER_FILE

# Appended to each script file. Ignored if empty.
SCRIPT_FOOTER
# Appended to each script file. Ignored if SCRIPT_FOOTER is set or empty.
# Default value: /var/mongosh/static/footer.js
SCRIPT_FOOTER_FILE
```

Inside your script you can use defined variables:

-   `SCRIPT_PATH` - path to the script currently executing
-   `SCRIPT_FILE` - file name of the script being executed
