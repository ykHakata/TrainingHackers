{
    connect_info => {
        host => $ENV{HACKERS_DB_HOST} || 'localhost',
        port => $ENV{HACKERS_DB_PORT} || 3306,
        username => $ENV{HACKERS_DB_USER} || 'root',
        password => $ENV{HACKERS_DB_PASSWORD},
        database => $ENV{HACKERS_DB_NAME} || 'hackers',
        connect_options => {
            mysql_enable_utf8 => 1,
            RaiseError => 1,
            AutoCommit => 1,
            PrintError => 0,
            AutoInactiveDestroy => 1,
        }
    },
}
