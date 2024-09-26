# Array of SQL files (without extensions)
$SqlFiles = @("ingest_listings", "ingest_calendar", "ingest_generated_reviews", "ingest_amenities_changelog")

# Paths
$DatabaseName = $env:snowsql_database
$SchemaName = $env:snowsql_schema

# Loop through each SQL file and run the ingestion
foreach ($SqlFile in $SqlFiles) {
    # Construct SQL file path and related variables
    $SqlPath = Join-Path -Path $PSScriptRoot -ChildPath "..\sql\$($SqlFile).sql"
    $ResolvedSqlPath = Resolve-Path -Path $SqlPath

    # Set unique table and stage destination based on SQL file name
    $TableName = $SqlFile.Replace("ingest_", "")
    $TableDestination = "$($DatabaseName).$($SchemaName).$($TableName)"
    $StageDestination = "@$($DatabaseName).$($SchemaName).%$($TableName)"

    # Run SnowSQL for each SQL file
    snowsql -c $env:snowsql_connection `
        -f $ResolvedSqlPath `
        -D database_name=$DatabaseName `
        -D schema_name=$SchemaName `
        -D table_destination=$TableDestination `
        -D stage_destination=$StageDestination `
        -o quiet=true `
        -o echo=false
}

Write-Host "Ingestion process completed for all tables."
