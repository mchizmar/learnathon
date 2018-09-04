echo password > acct.password && echo password >> acct.password;
cat acct.password | geth --datadir chaindata/ account new
rm acct.password;

