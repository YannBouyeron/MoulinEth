# Mixer d'ether decentralisé

struct round:
	
	end: timestamp
	
	depotBal: wei_value
	requestBal: wei_value
	
	verified: bool
	reversed: bool
	
	bonus: wei_value
	fee: wei_value
	
	deposer: map(address, wei_value)
	requester: map(address, wei_value)
	

# Events
	
Round: event({_ID:uint256, _end:timestamp})

Fee: event({_roundID:uint256, _amount:wei_value})

Depot: event({_roundID:uint256, _deposer:indexed(address), _amount:wei_value})

Request: event({_roundID:uint256, _requester:indexed(address), _amount:wei_value})

Withdraw: event({_roundID:uint256, _withdrawer:indexed(address), _amount:wei_value})

Backdraw: event({_roundID:uint256, _backdrawer:indexed(address), _amount:wei_value})

Verif: event({_roundID:uint256, _reversed:bool, _depotBal:wei_value, _requestBal:wei_value})



# Variables

rounder: public(map(uint256, round)) # map round number struct round

roundCounter: public(uint256)

delta: public(timedelta)

owner: public(address)

ownerBal: public(wei_value)

partsExc: public(uint256) # part (%) des excedents des tentatives de fraude revenant au owner

partsLoose: public(uint256) # part (%) des depots non reclamés revenant au owner


@public
def __init__():
	
	self.owner = 0x54105df187fB630A940FFAe0cE53789f45F80523
	
	self.partsExc = 5
	
	self.partsLoose = 5
	
	self.delta = 86400  # 24 heures
	

@public
def setParts(_exc:uint256, _loose:uint256):
	
	assert msg.sender == self.owner
	
	assert _exc <= 100
	assert _loose <= 100
	
	self.partsExc = _exc
	self.partsLoose= _loose
	
	

@public
def setDelta(_delta:timedelta):
	
	assert msg.sender == self.owner
	
	self.delta = _delta


@public
def initRound():

		
	if self.roundCounter != 0:
		
		assert self.rounder[self.roundCounter -1].verified == True
		
	
	self.rounder[self.roundCounter].end = block.timestamp + self.delta
	
	self.roundCounter += 1
	
	log.Round(self.roundCounter -1, block.timestamp + self.delta)


@public
@payable
def sendFee(_round:uint256):
	
	assert self.rounder[_round].end > block.timestamp
	
	self.rounder[_round].fee += msg.value
	
	log.Fee(_round, msg.value)
	
	
@public
@payable
def deposit(_round:uint256):
	
	assert self.rounder[_round].end > block.timestamp
	
	assert self.rounder[_round].deposer[msg.sender] == 0
	
	assert self.rounder[_round].requester[msg.sender] == 0 
	
	
	self.rounder[_round].depotBal += msg.value
	
	self.rounder[_round].deposer[msg.sender] = msg.value
	
	log.Depot(_round, msg.sender, msg.value)
	
	
@public
@payable
def request(_round:uint256):
	
	assert self.rounder[_round].end > block.timestamp
	
	assert self.rounder[_round].requester[msg.sender] == 0
	
	assert self.rounder[_round].deposer[msg.sender] == 0
	
	
	self.rounder[_round].requestBal += msg.value
	
	self.rounder[_round].requester[msg.sender] = msg.value
	
	log.Request(_round, msg.sender, msg.value)
	
	

@public
def verified(_round:uint256):
	
	
	assert self.rounder[_round].end < block.timestamp
	
	assert self.rounder[_round].verified == False
	
	
	if self.rounder[_round].requestBal < self.rounder[_round].depotBal:
		
		loose: wei_value = self.rounder[_round].depotBal - self.rounder[_round].requestBal
		
		ownerPart: wei_value = loose * as_unitless_number(self.partsLoose) / 100
		
		userPart: wei_value = loose - ownerPart
		
		assert ownerPart + userPart <= loose
		
		self.ownerBal += ownerPart
		
		self.rounder[_round].bonus = userPart
		
		

	elif self.rounder[_round].requestBal > self.rounder[_round].depotBal:
		
		exc: wei_value = self.rounder[_round].requestBal - self.rounder[_round].depotBal
		
		ownerPart: wei_value = exc * as_unitless_number(self.partsExc) / 100
		
		userPart: wei_value = exc - ownerPart
		
		assert ownerPart + userPart <= exc
	
		self.ownerBal += ownerPart
		
		self.rounder[_round].bonus = userPart
		
		self.rounder[_round].reversed = True
	


	self.rounder[_round].verified = True
	
	log.Verif(_round, self.rounder[_round].reversed, self.rounder[_round].depotBal, self.rounder[_round].requestBal)

	self.initRound()



@public
def withdraw(_round:uint256):
	
	assert self.rounder[_round].end < block.timestamp
	
	assert self.rounder[_round].verified == True
	
	assert self.rounder[_round].requestBal <= self.rounder[_round].depotBal
	
	amount: wei_value = self.rounder[_round].requester[msg.sender]
	
	self.rounder[_round].requester[msg.sender] = 0
	
	loosePrime: wei_value = amount * self.rounder[_round].bonus /self.rounder[_round].requestBal
	
	feePrime: wei_value = amount * self.rounder[_round].fee / self.rounder[_round].requestBal
	
	send(msg.sender, feePrime + loosePrime + amount * 2)
	
	log.Withdraw(_round, msg.sender, feePrime + loosePrime + amount * 2)
	
	
	
@public
def backdraw(_round:uint256):
	
	assert self.rounder[_round].end < block.timestamp
	
	assert self.rounder[_round].verified == True
	
	assert self.rounder[_round].reversed == True
	
	assert self.rounder[_round].requestBal > self.rounder[_round].depotBal
	
	amount: wei_value = self.rounder[_round].deposer[msg.sender]
	
	self.rounder[_round].deposer[msg.sender] = 0
	
	excPrime: wei_value = amount * self.rounder[_round].bonus / self.rounder[_round].depotBal
	
	feePrime: wei_value = amount * self.rounder[_round].fee / self.rounder[_round].depotBal
	
	send(msg.sender, feePrime + excPrime + amount * 2)
	
	log.Backdraw(_round, msg.sender, feePrime + excPrime + amount * 2)
	


@public
def ownerWithdraw():
	
	assert msg.sender == self.owner
	
	assert self.ownerBal > 0
	
	send(self.owner, self.ownerBal)
	
	self.ownerBal = 0
	
	
@public
def setOwner(_new:address):
	
	assert msg.sender == self.owner
	
	self.owner = _new
	
	
	
	
	
	
	
	
