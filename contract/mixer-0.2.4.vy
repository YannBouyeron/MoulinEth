# @version ^0.2.0

# Mixer d'ether decentralisé

struct round:
	
	end: uint256
	
	depotBal: uint256
	requestBal: uint256
	
	verified: bool
	reversed: bool
	
	bonus: uint256
	fee: uint256




# Events
	
event Round:
	_ID:uint256
	_end:uint256

event Fee:
	_roundID:uint256
	_amount:uint256

event Depot:
	_roundID:uint256
	_deposer:indexed(address)
	_amount:uint256

event Request:
	_roundID:uint256
	_requester:indexed(address)
	_amount:uint256

event Withdraw:
	_roundID:uint256
	_withdrawer:indexed(address)
	_amount:uint256

event Backdraw:
	_roundID:uint256
	_backdrawer:indexed(address)
	_amount:uint256

event Verif:
	_roundID:uint256
	_reversed:bool
	_depotBal:uint256
	_requestBal:uint256



# Variables

rounder: public(HashMap[uint256, round]) # map round number struct round

deposer: public(HashMap[uint256, HashMap[address, uint256]]) # map round : (address: value)

requester: public(HashMap[uint256, HashMap[address, uint256]])


roundCounter: public(uint256)

delta: public(uint256)

owner: public(address)

ownerBal: public(uint256)

partsExc: public(uint256) # part (%) des excedents des tentatives de fraude revenant au owner

partsLoose: public(uint256) # part (%) des depots non reclamés revenant au owner


@external
def __init__():
	
	self.owner = 0x54105df187fB630A940FFAe0cE53789f45F80523 
	
	self.partsExc = 5
	
	self.partsLoose = 5
	
	self.delta = 86400  # 24 heures
	

@external
def setParts(_exc:uint256, _loose:uint256):
	
	assert msg.sender == self.owner
	
	assert _exc <= 100
	assert _loose <= 100
	
	self.partsExc = _exc
	self.partsLoose= _loose
	
	

@external
def setDelta(_delta:uint256):
	
	assert msg.sender == self.owner
	
	self.delta = _delta


@internal
def _initRound():

		
	if self.roundCounter != 0:
		
		assert self.rounder[self.roundCounter -1].verified == True
		
	
	self.rounder[self.roundCounter].end = block.timestamp + self.delta
	
	self.roundCounter += 1
	
	log Round(self.roundCounter -1, block.timestamp + self.delta)



@external
def initRound():

	self._initRound()



@external
@payable
def sendFee(_round:uint256):
	
	assert self.rounder[_round].end > block.timestamp
	
	self.rounder[_round].fee += msg.value
	
	log Fee(_round, msg.value)
	
	
@external
@payable
def deposit(_round:uint256):
	
	assert self.rounder[_round].end > block.timestamp
	
	assert self.deposer[_round][msg.sender] == 0
	
	assert self.requester[_round][msg.sender] == 0 
	
	
	self.rounder[_round].depotBal += msg.value
	
	self.deposer[_round][msg.sender] = msg.value
	
	log Depot(_round, msg.sender, msg.value)
	
	
@external
@payable
def request(_round:uint256):
	
	assert self.rounder[_round].end > block.timestamp
	
	assert self.requester[_round][msg.sender] == 0
	
	assert self.deposer[_round][msg.sender] == 0
	
	
	self.rounder[_round].requestBal += msg.value
	
	self.requester[_round][msg.sender] = msg.value
	
	log Request(_round, msg.sender, msg.value)
	
	

@external
def verified(_round:uint256):
	
	
	assert self.rounder[_round].end < block.timestamp
	
	assert self.rounder[_round].verified == False
	
	
	if self.rounder[_round].requestBal < self.rounder[_round].depotBal:
		
		loose: uint256 = self.rounder[_round].depotBal - self.rounder[_round].requestBal
		
		ownerPart: uint256 = loose * self.partsLoose / 100
		
		userPart: uint256 = loose - ownerPart
		
		assert ownerPart + userPart <= loose
		
		self.ownerBal += ownerPart
		
		self.rounder[_round].bonus = userPart
		
		

	elif self.rounder[_round].requestBal > self.rounder[_round].depotBal:
		
		exc: uint256 = self.rounder[_round].requestBal - self.rounder[_round].depotBal
		
		ownerPart: uint256 = exc * self.partsExc / 100
		
		userPart: uint256 = exc - ownerPart
		
		assert ownerPart + userPart <= exc
	
		self.ownerBal += ownerPart
		
		self.rounder[_round].bonus = userPart
		
		self.rounder[_round].reversed = True
	


	self.rounder[_round].verified = True
	
	log Verif(_round, self.rounder[_round].reversed, self.rounder[_round].depotBal, self.rounder[_round].requestBal)

	self._initRound()



@external
def withdraw(_round:uint256):
	
	assert self.rounder[_round].end < block.timestamp
	
	assert self.rounder[_round].verified == True
	
	assert self.rounder[_round].requestBal <= self.rounder[_round].depotBal
	
	amount: uint256 = self.requester[_round][msg.sender]
	
	self.requester[_round][msg.sender] = 0
	
	loosePrime: uint256 = amount * self.rounder[_round].bonus /self.rounder[_round].requestBal
	
	feePrime: uint256 = amount * self.rounder[_round].fee / self.rounder[_round].requestBal
	
	send(msg.sender, feePrime + loosePrime + amount * 2)
	
	log Withdraw(_round, msg.sender, feePrime + loosePrime + amount * 2)
	
	
	
@external
def backdraw(_round:uint256):
	
	assert self.rounder[_round].end < block.timestamp
	
	assert self.rounder[_round].verified == True
	
	assert self.rounder[_round].reversed == True
	
	assert self.rounder[_round].requestBal > self.rounder[_round].depotBal
	
	amount: uint256 = self.deposer[_round][msg.sender]
	
	self.deposer[_round][msg.sender] = 0
	
	excPrime: uint256 = amount * self.rounder[_round].bonus / self.rounder[_round].depotBal
	
	feePrime: uint256 = amount * self.rounder[_round].fee / self.rounder[_round].depotBal
	
	send(msg.sender, feePrime + excPrime + amount * 2)
	
	log Backdraw(_round, msg.sender, feePrime + excPrime + amount * 2)
	


@external
def ownerWithdraw():
	
	assert msg.sender == self.owner
	
	assert self.ownerBal > 0
	
	send(self.owner, self.ownerBal)
	
	self.ownerBal = 0
	
	
@external
def setOwner(_new:address):
	
	assert msg.sender == self.owner
	
	self.owner = _new
	
