#Unlock the account 
echo Creating New Account
NEWADDRESS=$(geth --datadir node1 --exec "personal.newAccount('password')" attach ipc:/home/ec2-user/ethereum/node1/geth.ipc)

echo Unlocking $NEWADDRESS
echo geth --datadir node1 --exec \"personal.unlockAccount\($NEWADDRESS,\'password\'\)\" attach ipc:/home/ec2-user/ethereum/node1/geth.ipc
geth --datadir node1 --exec "personal.unlockAccount($NEWADDRESS,'password')" attach ipc:/home/ec2-user/ethereum/node1geth.ipc

echo  $NEWADDRESS
geth --datadir node1 --exec "eth.sendTransaction({from:eth.coinbase, to:$NEWADDRESS, value:10})" attach ipc:/home/ec2-user/ethereum/node1geth.ipc

