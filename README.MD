# Dapp

## Requirements

1. **Node.js and npm Installation**
   - Install Node.js and npm. You can download and install Node.js from [here](https://nodejs.org/).

2. **pnpm Installation**
   - Once Node.js is installed, install `pnpm` globally by running:
     ```
     npm install -g pnpm
     ```

3. **Metamask Extension Setup**
   - Install the Metamask browser extension [here](https://metamask.io/download.html).

## How to Run

1. **Install Dependencies**
     ```
     pnpm install
     ```

2. **Run Backend Services**
  - Change directory to `/backend`

  - For the first time run (This only need to rerun when contract is edited)
    ```
    pnpm build
    ```

  - Run these commands in 2 different terminals
    ```bash
    pnpm node

    # 10 Accounts will be listed. Choose one and take its address and private key. These will be used later on.
    ```
    ```
    pnpm deploy:local
    ```

3. **Run Frontend**
  - Update `frontend/.env` at field `VITE_ACCOUNT_ADDRESS` for address from account you selected above
  - Change directory to `/frontend` and run

    ```
    pnpm dev
    ```

4. **Setup MetaMask**

  - Add custom network with following infos
    1. Url: http://127.0.0.1:8554
    2. ChainId: 1337
    3. Currency: ETH

  - Add account with private key from account you selected above

3. **Access the Application**

  - Open your browser and enter the following URL:
    [http://localhost:5173/](http://localhost:5173/)


> Ensure all terminals remain active to keep both frontend and backend services running.
