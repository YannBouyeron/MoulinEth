# MoulinEth

Unstoppable Ethereum Mixer 100% Decentralized 0% Fee 100% Free

Tester sur Ropsten: https://ipfs.io/ipns/QmQLV56ihsFxyyvp1HyXbamCNcwUDiBnPnbhuvUb83EF7H




### Comment participer à un round ?

- Vérifiez qu’un round est actif. Dans le cas contraire, cliquez sur **init Round**.

- Utilisez votre adresse Ethereum de dépôt pour déposer les Ether que vous souhaitez mixer: indiquez le montant en wei que vous souhaitez mixer, puis cliquez sur **Send**.

- Notez bien l’ID du round auquel vous avez participé, et prenez connaissance de la date et de l’heure  à laquelle se termine le round.

- Avant la fin du round, utiliser votre adresse Ethereum de retrait pour faire une demande de retrait en versant une caution  égale (ou inférieure) au montant déposé à l’étape précédente: indiquez le montant en wei de votre caution, puis cliquez sur **Request**.

- Vous pouvez faire plusieurs dépôts dans le même round (avec différentes adresses de dépôts) et / ou plusieurs demandes de retraits (avec différentes adresses de retraits), mais vous ne pouvez pas utiliser une même adresse pour les dépôts et les retraits.

- Vous pouvez faire votre ou vos demandes de retraits avant de faire votre ou vos dépôts à condition de faire les dépôts et les retraits dans le même round et avant la fin du round et de veiller à ce que la somme des cautions de retraits soit égale (ou inférieure) à la somme des dépôts.

- À la fin du round et après sa vérification, si le total des demandes de retraits est égal au total des dépôts vous pourrez récupérer votre dépôt et votre caution de retrait avec votre **adresse de retrait**. Recherchez le round auquel vous avez participé dans la liste des rounds fermés, et cliquez sur **Withdraw**. 
	
- À la fin du round et après sa vérification, si le total des demandes de retraits est inférieur au total des dépôts, le montant non réclamé sera partagé (bonus) entre les participants; vous pourrez récupérer votre dépôt, votre retrait et votre bonus avec votre **adresse de retrait**. Recherchez le round auquel vous avez participé dans la liste des rounds fermés, et cliquez sur **Withdraw**. 

- À la fin du round et après sa vérification si le total des demandes de retraits est supérieur au total des dépôts, le round est renversé , un ou plusieurs participants ont essayé de récupérer des Ether qu’ils n’avaient pas déposés, ils perdent leurs cautions qui seront partagées (bonus) entre les autres participants. Vous pourrez récupérer votre  dépôt , votre caution et votre bonus en utilisant votre **adresse de dépôts**. Recherchez le round auquel vous avez participé dans la liste des rounds fermés, et cliquez sur **Backdraw**. Vos Ether n’ont pas été mixés, mais le bonus vous dédommage en partie !
	
	
	
### Comment mon adresse de retrait peut-elle être "anonyme", si je dois déjà posséder des Ether dessus afin de verser la caution ?

- Créez une nouvelle adresse Ethereum.

- Utilisez un faucet ou achetez une petite quantité de wei de manière anonyme.

- Faites des rounds avec des montants de plus en plus importants pour disposer de suffisamment d’Ether "anonymes"... ce qui vous permettra de mixer de plus en plus d’Ether.

### Pourquoi et comment vérifier un round ?

Lors de la vérification du round, le smart contract Ethereum compare le total des dépôts au total des cautions de retraits afin de décider si le round est validé ou renversé. Si les deux montants ne sont pas égaux, le smart contract calcule le bonus qui sera partagé entre les participants.

### Peut-on faire une demande de retrait (en versant une caution) sans avoir fait de dépôt ?

Oui ! Mais vous perdrez votre caution de retrait , sauf si un ou plusieurs participants oublient de faire leur demande de retrait (ou font des demandes de retraits inférieures à leurs dépôts) et que le montant des dépôts non réclamés est supérieur ou égal au montant de votre caution, auquel cas vous gagnerez le double de votre caution.


### Je ne parviens pas à faire ma demande de retrait !

Vérifiez que:

- Le round est encore actif.

- L’adresse utilisée pour votre demande de retrait est différente de celle utilisée pour votre dépôt. 

- L’adresse utilisée pour votre demande de retrait n’a pas déjà été utilisée dans le même round pour faire une autre demande de retrait.



### Je n’ai pas fait de demande de retrait dans la limite de temps du round !

C’est vraiment dommage pour vous, mais votre dépôt est définitivement perdu, sauf si le round est renversé, auquel cas vous gagnerez le double de votre dépôt.

### Je ne parviens pas à retirer mes Ethers !

Vérifiez que:

- Le round est terminé et vérifié.

- L’ID du round correspond bien au round auquel vous avez participé.

- Vous utilisez la bonne adresse: adresse de retrait en cas de Withdraw (round validé), adresse de dépôt en cas de Backdraw (round renversé).


### A quoi servent les bonus et le bouton «Send Fee» ?

Les bonus correspondent aux dépôts non réclamés ou aux cautions excédentaires ; ils sont partagés entre les participants lors du Withdraw ou du Backdraw. Leurs montants ne sont connus qu’après la vérification du round.

Les bonus fee que n’importe qui peut verser en cliquant sur **Send Fee** sont des incitations à participer au round. Ces bonus fee seront partagés entre les participants du round lors du Withdraw ou du Backdraw. En incitant à participer au round , il y’aura davantage de participants ce qui augmentera l’efficacité mixage.


### J’ai reçu davantage d’Ether que ce que j’ai versé ! Est-ce normal ?

Oui, cela peut arriver. Ce sont des bonus qui correspondent soit à des dépôts non retirés, soit à des cautions versées sans avoir fait de dépôts , soit à des incitations à participer au round (bonus fee).


### Comment accéder à cette dapp ?

Via un navigateur web compatible web3 (Metamask):

- dapp (version de test sur ropsten): https://ipfs.io/ipns/QmQLV56ihsFxyyvp1HyXbamCNcwUDiBnPnbhuvUb83EF7H/
- dapp (mainnet): cette dapp n’est pas encore déployée sur le mainnet.

Via un noeud ipfs:

- ipns hash (version de test sur ropsten): QmQLV56ihsFxyyvp1HyXbamCNcwUDiBnPnbhuvUb83EF7H
- ipns hash (mainnet): cette dapp n’est pas encore déployée sur le mainnet.


### 100% Free ! Ca signifie quoi ?

Le smart contract Ethereum, et la dapp sont sous licence AGPL V3, il s’agit d’une licence libre ("open source"), dont vous pouvez consulter les termes : https://www.gnu.org/licenses/agpl-3.0.html

Les sources du smart contract et de la dapp sont disponibles sur github: https://github.com/YannBouyeron/MoulinEth.git

### 100% Décentralisé ! Ca signifie quoi ?

- Ce mixer fonctionne grâce à un smart contract hébergé sur la Blockchain Ethereum. 

- Ce smart contract ne contient aucune fonction permettant de l’arrêter !

- L’application web est hébergée sur IPFS. L’IPFS ou InterPlanetary File System est un protocole pair à pair (p2p) de distribution de contenu adressable par hypermédia. Il permet de "stocker" des fichiers ou des arborescences de fichiers de manière décentralisée et permanente, et d’y accéder via un noeud ipfs ou via un navigateur web.

- **Cette dapp est donc totalement "unstoppable" !**


### Ce service est-Il légal ?

- J’espère bien.

- Il est en revanche strictement interdit d’utiliser cette dapp ou son smart contract à des fins illégales.

### Pourquoi ce service est il gratuit ?

- Parceque je n’ai pas passé beaucoup de temps à le développer.

- Parceque je récupère 5% des bonus

- Parceque, pour des raisons de confiance vis à vis des utilisateurs,  j’ai fait le choix de rendre cette dapp et son smart contract libres ("open source") ce qui d’après les termes de la licence AGPL V3 autorise (sous certaines conditions) n’importe qui à copier , améliorer , déployer cette dapp au risque de me faire de la concurrence.
