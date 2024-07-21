{
	gsub(/om_version_goes_here/,OM_VERSION);
	gsub(/om_om_memory/,om_om_memory);
	gsub(/om_appdb_memory/,om_appdb_memory);
    print;
}
