def settings_xml(url, password, username): 
    return """<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
        <mirrors>
            <mirror>
                <id>artifactory</id>
                <name>Tanzu seal Internal Repo</name>
                <url>{}</url>
                <mirrorOf>*</mirrorOf>
            </mirror>
        </mirrors>
        <servers>
             <server>
                <id>artifactory</id>
                <username>{}</username>
                <password>{}</password>
             </server>
        </servers>
    </settings>""".format(url, username, password)
end
