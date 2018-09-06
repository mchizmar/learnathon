#Unlock the account 
echo Creating New Account
NEWADDRESS=$(geth --datadir chaindata --exec "personal.newAccount('password')" attach ipc:/Users/chizmm1/Projects/learnathon/chaindata/geth.ipc)

echo Unlocking $NEWADDRESS
echo geth --datadir chaindata --exec \"personal.unlockAccount\($NEWADDRESS,\'password\'\)\" attach ipc:/Users/chizmm1/Projects/learnathon/chaindata/geth.ipc
geth --datadir chaindata --exec "personal.unlockAccount($NEWADDRESS,'password')" attach ipc:/Users/chizmm1/Projects/learnathon/chaindata/geth.ipc

echo  $NEWADDRESS
geth --datadir chaindata --exec "eth.sendTransaction({from:eth.coinbase, to:$NEWADDRESS, value:10})" attach ipc:/Users/chizmm1/Projects/learnathon/chaindata/geth.ipc

