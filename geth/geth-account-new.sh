
echo password > acct.password && echo password >> acct.password;
cat acct.password | geth --datadir chaindata/ account new > newaddress.txt 

#Parse the output file for the new address and set the variable
NEWADDRESS=$(grep Address newaddress.txt  | cut -d "{" -f2 | cut -d "}" -f1)

echo New Address Created $NEWADDRESS
echo Private key file: `ls -l chaindata/keystore/*$NEWADDRESS*`

#Cleanup
rm acct.password;
rm newaddress.txt; 

#Unlock the account 
echo Unlocking $NEWADDRESS
echo geth --exec "personal.unlockAccount('$NEWADDRESS','password')" attach ipc:/Users/chizmm1/Projects/learnathon/chaindata/geth.ipc
geth --exec "personal.unlockAccount('$NEWADDRESS','password')" attach ipc:/Users/chizmm1/Projects/learnathon/chaindata/geth.ipc
#geth --exec "eth.sendTransaction({from:eth.coinbase, to:'$NEWADDRESS', value:10})" attach ipc:/Users/chizmm1/Projects/learnathon/chaindata/geth.ipc
