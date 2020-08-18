function roundit() {

var eve = ccc.allEvents({fromBlock: 3092520, toBlock: 'latest'});

					
eve.get(function(err, result) {

		
		var timestamp = Math.floor(Date.now() / 1000);
		
		
		var fin = [];
		var amount = [];
		var verif = [];
		var reversed = [];
		var depot = [];
		var request = [];
		var fee = [];
		
		//restructuration des event
		
		for(var i=0; i<result.length; i++) {

			
	
			if (result[i].event == 'Round') {	
				
				fin[result[i].args._ID] = result[i].args._end;
				
				
				if (request[result[i].args._ID] == null) {

					request[result[i].args._ID] = 0;

				};

				if (depot[result[i].args._ID] == null) {

					depot[result[i].args._ID] = 0;

				};

				if (fee[result[i].args._ID] == null) {

					fee[result[i].args._ID] = 0;

				};
			
			
			
					
				};

			if (result[i].event == 'Fee') {

				if (fee[result[i].args._roundID] == null) {

					fee[result[i].args._roundID] = 0;

				};

				
				fee[result[i].args._roundID] = parseInt(fee[result[i].args._roundID]) + parseInt(result[i].args._amount);
				
				};		
			
				
			if (result[i].event == 'Depot') {

				if (depot[result[i].args._roundID] == null) {

					depot[result[i].args._roundID] = 0;

				};

				depot[result[i].args._roundID] = parseInt(depot[result[i].args._roundID])+ parseInt(result[i].args._amount);
				
				
				};		
				
			
			if (result[i].event == 'Request') {

				if (request[result[i].args._roundID] == null) {

					request[result[i].args._roundID] = 0;

				};
			
				request[result[i].args._roundID] = parseInt(request[result[i].args._roundID])+ parseInt(result[i].args._amount);
				
				};		
			
					
			
			if (result[i].event == 'Verif') {
			
			
				verif.push(result[i].args._roundID);
				
				if (result[i].args._reversed == true) {

					reversed.push(result[i].args._roundID);
				};

				};		
			
		};
		
		var count = fin.length;

		for(var j=0; j<count; j++) {

			var i = count - j - 1 ;
		

			var date = new Date(Number(1000 * fin[i]));

		
			if (fin[i] > timestamp) {

			
				var h = "<h1>Active Round</h1><p>Round ID: " + i + "</p><p>End: " + date + "</p><p>Deposit: " + depot[i]*10**-18 + " Ether</p><p>Request: " + request[i]*10**-18 + " Ether</p> <p>Bonus fee: " + fee[i]*10**-18 + " Eth</p><form name='DEP' id='DEP' class=''><input type='text' name='amount' id='amount' placeholder='20000000000'></br></br><input type='button' class='bf_button' onClick='deposer("+i+")' value='Deposit'><input type='button' class='bf_button' onClick='requester("+i+")' value='Request'><input type='button' class='bf_button' onClick='feesend("+i+")' value='Add Fee'> </form>"

		
				document.getElementById("bf").innerHTML = h;
		
			};



			if (fin[i] < timestamp) {
			
				if (!(i in verif)) {

					var h = "<h1>Inactive Round</h1><p>Round ID: " + i + "</p><p>End: " + date + "</p><p>Deposit: " + depot[i]*10**-18 + " Ether</p><p>Request: " + request[i]*10**-18 + " Ether</p><p>Bonus fee: " + fee[i]*10**-18 + " Eth</p><p>This round is not checked at this time.</p><form><input type='button' class='bf_button' onClick='verifier(" + i + ")' value='Check Round'><input type='button' class='bf_button' onClick='verifier(" + i + ")' value='Init Round'></form>";

					document.getElementById("bf").innerHTML = h;
				};



				if (i in verif && depot[i] >= request[i]) {

					var h = "<div class='ligne'><div class='ligne_element'>" + i + "</div><div class='ligne_element'>" + fee[i]*10**-18 + " Eth</div><div class= 'ligne_element'>" + depot[i]*10**-18 + " Eth</div><div class= 'ligne_element'>" + request[i]*10**-18 +  " Eth</div><div class= 'ligne_element'>Validated Round.</div><div class= 'ligne_element'><input type='button' class='bf_button' onClick='cash(" + i + ")' value='Withdraw'></div></div>";

					document.getElementById("rounds").innerHTML += h;
				};


				
				if (i in verif && depot[i] < request[i]) {

					var h = "<div class='ligne'><div class='ligne_element'>" + i + "</div><div class='ligne_element'>" + fee[i]*10**-18 + " Eth</div><div class= 'ligne_element'>" + depot[i]*10**-18 + " Eth</div><div class= 'ligne_element'>" + request[i]*10**-18 +  " Eth</div><div class= 'ligne_element'>Reversed round.</div><div class= 'ligne_element'><input type='button' class='bf_button' onClick='back(" + i + ")' value='Backdraw'></div></div>";

					document.getElementById("rounds").innerHTML += h;
				};





			};


			






		};
		
});

}

roundit();

// deposit

function deposer(ID) {

			if(web3.eth.defaultAccount === undefined) {

				alert("No accounts found. If you're using MetaMask, " + "please unlock it first and reload the page.");

			}
			
			var amount = document.DEP.amount.value;
			
			ccc.deposit(ID, {gas: 300000, from: web3.eth.accounts[0], value:amount}, function (err, hash) {

				if (err) {
				
					alert(err)
					return(err);
				}
				
				alert("Transaction en cours...");
			
				waitForReceipt(hash, function () {
					
					alert("Transaction terminée.");
					
					document.getElementById("rounds").innerHTML = "";
					roundit();
				});
			});
			
		
		}
		

// request

function requester(ID) {

			if(web3.eth.defaultAccount === undefined) {

				alert("No accounts found. If you're using MetaMask, " + "please unlock it first and reload the page.");

			}
			
			var amount = document.DEP.amount.value;
			
			ccc.request(ID, {gas: 300000, from: web3.eth.accounts[0], value:amount}, function (err, hash) {

				if (err) {
				
					alert(err)
					return(err);
				}
				
				
				alert("Transaction en cours...");
			
				waitForReceipt(hash, function () {
					
					alert("Transaction terminée.");
					
					document.getElementById("rounds").innerHTML = "";
					roundit();
				});
			});
			
		
		}



// verifier

function verifier(ID) {

			if(web3.eth.defaultAccount === undefined) {

				alert("No accounts found. If you're using MetaMask, " + "please unlock it first and reload the page.");

			}
			

			
			ccc.verified(ID, {gas: 300000, from: web3.eth.accounts[0], value:0}, function (err, hash) {

				if (err) {
				
					alert(err)
					return(err);
				}
				
				
				alert("Transaction en cours...");
			
				waitForReceipt(hash, function () {
					
					alert("Transaction terminée.");
					
					document.getElementById("rounds").innerHTML = "";
					roundit();
				});
			});
			
		
		}




// initRound

function initier() {

			if(web3.eth.defaultAccount === undefined) {

				alert("No accounts found. If you're using MetaMask, " + "please unlock it first and reload the page.");

			}
			
			
			ccc.initRound({gas: 300000, from: web3.eth.accounts[0], value:0}, function (err, hash) {

				if (err) {
				
					alert(err)
					return(err);
				}
				
				alert("Transaction en cours...");
			
				waitForReceipt(hash, function () {
					
					alert("Transaction terminée.");
					
					document.getElementById("rounds").innerHTML = "";
					roundit();
				});
			});
			
		
		}









// sendfee

function feesend(ID) {

			if(web3.eth.defaultAccount === undefined) {

				alert("No accounts found. If you're using MetaMask, " + "please unlock it first and reload the page.");

			}
			
			

			var amount = document.DEP.amount.value;
			
			ccc.sendFee(ID, {gas: 300000, from: web3.eth.accounts[0], value:amount}, function (err, hash) {

				if (err) {
				
					alert(err)
					return(err);
				}
				
				alert("Transaction en cours...");
			
				waitForReceipt(hash, function () {
					
					alert("Transaction terminée.");
					
					document.getElementById("rounds").innerHTML = "";
					roundit();
				});
			});
			
		
		}
		






//withdraw

function cash(ID) {

			if(web3.eth.defaultAccount === undefined) {

				alert("No accounts found. If you're using MetaMask, " + "please unlock it first and reload the page.");

			}
			

			
			ccc.withdraw(ID, {gas: 300000, from: web3.eth.accounts[0], value:0}, function (err, hash) {

				if (err) {
				
					alert(err)
					return(err);
				}
				
				
				alert("Transaction en cours...");
			
				waitForReceipt(hash, function () {
					
					alert("Transaction terminée.");
					
					document.getElementById("rounds").innerHTML = "";
					roundit();
				});
			});
			
		
		}





//backdraw

function back(ID) {

			if(web3.eth.defaultAccount === undefined) {

				alert("No accounts found. If you're using MetaMask, " + "please unlock it first and reload the page.");

			}
			

			
			ccc.backdraw(ID, {gas: 300000, from: web3.eth.accounts[0], value:0}, function (err, hash) {

				if (err) {
				
					alert(err)
					return(err);
				}
				
				
				alert("Transaction en cours...");
			
				waitForReceipt(hash, function () {
					
					alert("Transaction terminée.");
					
					document.getElementById("rounds").innerHTML = "";
					roundit();
				});
			});
			
		
		}







// wait for receipt

function waitForReceipt(hash, cb) {
	
			web3.eth.getTransactionReceipt(hash, function (err, receipt) {
		
				if (err) {
					alert(err);
				}

				if (receipt !== null) {

					if (cb) {
						cb(receipt);
					}
				} 
		
				else {

					window.setTimeout(function () {
				
						waitForReceipt(hash, cb);
					}, 1000);

				}
			});
		}
		



		
		
