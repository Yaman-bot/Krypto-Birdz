import React, { Component } from 'react'
import Web3 from "web3";
import KryptoBird from './abis/KryptoBird.json'
import { MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn } from 'mdb-react-ui-kit';
import './App.css';

class App extends Component {
	constructor(props) {
		super(props);
		this.state = {
			account: '',
			contract: null,
			totalSupply: 0,
			kryptoBirdz: []
		}
	}

	async componentDidMount() {
		await this.loadWeb3();
		await this.loadBlockchainData();
	}

	// first up is to detect ethereum provider
	async loadWeb3() {
		if (window.ethereum) {
			window.web3 = new Web3(window.ethereum)
			await window.ethereum.enable()
		}
		else if (window.web3) {
			window.web3 = new Web3(window.web3.currentProvider)
		}
		else {
			window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
		}
	}

	async loadBlockchainData() {
		const web3 = window.web3
		const accounts = await web3.eth.getAccounts()
		this.setState({ account: accounts[0] })

		const networkId = await web3.eth.net.getId()           //blockchain network id 
		const networkData = KryptoBird.networks[networkId]
		if (networkData) {
			const abi = KryptoBird.abi;
			const address = networkData.address;

			const contract = new web3.eth.Contract(abi, address)
			this.setState({ contract })

			const totalSupply = await contract.methods.totalSupply().call()
			this.setState({ totalSupply })

			for (let i = 1; i <= totalSupply; i++) {
				const KryptoBird = await contract.methods.KryptoBirdz(i - 1).call()
				this.setState({
					kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
				})
			}
		} else {
			window.alert('Smart contract not deployed')
		}
	}

	mint = (kryptoBird) => {
		this.state.contract.methods.mint(kryptoBird).send({ from: this.state.account })
			.once('receipt', (receipt) => {
				this.setState({
					kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
				})
			})
	}

	render() {
		return (
			<>
				<div className='container-filled'>
					<nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
						<div className='navbar-brand col-sm-3 col-md-3 mr-0' style={{ color: 'white' }}>
							Krypto Birdz NFTs (Non Fungible Tokens)
						</div>
						<ul className='navbar-nav px-3'>
							<li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
								<small className='text-white'>
									{this.state.account}
								</small>
							</li>
						</ul>
					</nav>

					<div className='container-fluid mt-1'>
						<div className='row'>
							<main role='main'
								className='col-lg-12 d-flex text-center'>
								<div className='content mr-auto ml-auto'
									style={{ opacity: '0.8' }}>
									<h1 style={{ color: 'black' }}>
										KryptoBirdz - NFT Marketplace</h1>
									<form onSubmit={(event) => {
										event.preventDefault()
										const kryptoBird = this.kryptoBird.value
										this.mint(kryptoBird)
									}}>
										<input
											type='text'
											placeholder='Add a file location'
											className='form-control mb-1'
											ref={(input) => this.kryptoBird = input}
										/>
										<input style={{ margin: '6px' }}
											type='submit'
											className='btn btn-primary btn-black'
											value='MINT'
										/>
									</form>
								</div>
							</main>
						</div>
						<hr></hr>
						<div className='row textCenter'>
							{this.state.kryptoBirdz.map((kryptoBird, key) => {
								return (
									<div >
										<div>
											<MDBCard className='token img' style={{ maxWidth: '22rem' }}>
												<MDBCardImage src={kryptoBird} position='top' height='250rem' style={{ marginRight: '4px' }} />
												<MDBCardBody>
													<MDBCardTitle> KryptoBirdz </MDBCardTitle>
													<MDBCardText> The KryptoBirdz are 20 uniquely generated KBirdz from the cyberpunk cloud galaxy Mystopia! There is only one of each bird and each bird can be owned by a single person on the Ethereum blockchain. </MDBCardText>
													<MDBBtn href={kryptoBird}>Download</MDBBtn>
												</MDBCardBody>
											</MDBCard>
										</div>
									</div>
								)
							})}
						</div>
					</div>
				</div>
			</>
		)
	}

};

export default App;
