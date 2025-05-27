import { useProperty } from './hooks/useProperty';
import './App.css';

function App() {
  const { properties, currentAccount, connectWallet, addProperty, buyProperty } = useProperty();

  const handleSubmit = (e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    addProperty(formData.get('title'), formData.get('price'));
    e.target.reset();
  };

  return (
    <div className="App">
      <header>
        <h1>Real Estate Marketplace</h1>
        {!currentAccount ? (
          <button onClick={connectWallet}>Connect Wallet</button>
        ) : (
          <small>Connected: {currentAccount.slice(0, 6)}...{currentAccount.slice(-4)}</small>
        )}
      </header>

      <main>
        <form onSubmit={handleSubmit}>
          <h2>Add New Property</h2>
          <input name="title" placeholder="Property title" required />
          <input name="price" placeholder="Price in ETH" type="number" step="0.01" required />
          <button type="submit">List Property</button>
        </form>

        <div className="properties">
          <h2>Available Properties ({properties.length})</h2>
          {properties.map(prop => {
            console.log("Property:", prop.title, prop.owner, "Is listed:", prop.isListed, "Current:", currentAccount);
            return(
            <div key={prop.id} className="property-card">
              <h3>{prop.title}</h3>
              <p>Price: {prop.price} ETH</p>
              <p>Owner: {prop.owner.slice(0, 6)}...{prop.owner.slice(-4)}</p>
              
              {prop.isListed && currentAccount?.toLowerCase() !== prop.owner.toLowerCase() && (
  <button onClick={() => buyProperty(prop.id, prop.price)}>Purchase</button>
  
)}

            </div>
            );
})}
        </div>
      </main>
    </div>
  );
}

export default App;