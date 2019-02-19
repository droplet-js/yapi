exports.parseConfig() {
    return {
        port: process.env.YAPI_PORT,
        closeRegister: process.env.YAPI_CLOSEREGISTER == 'true' ? true : false,
        versionNotify: process.env.YAPI_VERSIONNOTIFY == 'true' ? true : false,
        adminAccount: process.env.YAPI_ADMINACCOUNT,
        adminPassword: process.env.YAPI_ADMINPASSWORD,
        db: {
            connectString: process.env.YAPI_DB_CONNECTSTRING,
            servername: process.env.YAPI_DB_SERVERNAME,
            port: parseInt(process.env.YAPI_DB_PORT),
            DATABASE: process.env.YAPI_DB_DATABASE,
            user: process.env.YAPI_DB_USER,
            pass: process.env.YAPI_DB_PASS
        },
        mail: {
            enable: process.env.YAPI_MAIL_ENABLE == 'true' ? true : false,
            host: process.env.YAPI_MAIL_HOST,
            port: parseInt(process.env.YAPI_MAIL_PORT),
            from: process.env.YAPI_MAIL_FROM,
            auth: {
                user: process.env.YAPI_MAIL_AUTH_USER,
                pass: process.env.YAPI_MAIL_AUTH_PASS
            }
        },
        ldapLogin: {
            enable: process.env.YAPI_LDAPLOGIN_ENABLE == 'true' ? true : false,
            server: process.env.YAPI_LDAPLOGIN_SERVER,
            baseDn: process.env.YAPI_LDAPLOGIN_BASEDN,
            bindPassword: process.env.YAPI_LDAPLOGIN_BINDPASSWORD,
            searchDn: process.env.YAPI_LDAPLOGIN_SEARCHDN,
            searchStandard: process.env.YAPI_LDAPLOGIN_SEARCHSTANDARD,
            emailPostfix: process.env.YAPI_LDAPLOGIN_EMAILPOSTFIX,
            emailKey: process.env.YAPI_LDAPLOGIN_EMAILKEY,
            usernameKey: process.env.YAPI_LDAPLOGIN_USERNAMEKEY
        }
    };
};
