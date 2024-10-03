# Internal Wallet Transactional System (API)

### Requirements
- Based on relationships every entity e.g. User, Team, Stock or any other should have their own defined "wallet" to which we could transfer money or withdraw
- Every request for credit/debit (deposit or withdraw) should be based on records in database for given model
- Every instance of a single transaction should have proper validations against required fields and their source and targetwallet, e.g. from who we are taking money and transferring to whom? (Credits == source wallet == nil, Debits == targetwallet == nil)
- Each record should be created in database transactions to comply with ACID standards
- Balance for given entity (User, Team, Stock) should be calculated by summing records

### Tasks
1. Architect generic wallet solution (money manipulation) between entities (User, Stock, Team or any other)
2. Create model relationships and validations for achieving proper calculations of every wallet, transactions
3. Use STI (or any other design pattern) for proper money manipulation
4. Apply your own sign in (new session solution, no sign up is needed) without any external gem
5. Create a LatestStockPrice library (in lib folder in “gem style”) for “price”, “prices” and “price_all” endpoints - https://rapidapi.com/suneetk92/api/latest-stock-price


### Note

The `/price`, `/prices`, and `/price_all` endpoints are no longer available at [rapidapi latest stock price v1](https://rapidapi.com/suneetk92/api/latest-stock-price). Instead, there is now an `/any` endpoint that serves as a replacement for `/price_all`.

### Instruction
1. Clone this repository
2. Install dependency
    ```shell
    bundle install
    ```
3. Create the database
    ```shell
    rails db:create && rails db:migrate
    ```
4. Add credential
    ```shell
    EDITOR="nano" rails credentials:edit
    ```
    Add this line:
    ```yaml
    rapidapi:
        api_key: YOUR_RAPIDAPI_KEY
    ```
5. Start the server
    ```shell
    rails server
    ```

### Endpoint

#### Login
- POST `/login`
    - Body
        | Field | Required |
        | ---- | -- |
        | email | yes |
        | password | yes |
    - Success Response
        ```json
        {
            "token": "d8d14db6690588292296",
            "message": "Login successful"
        }
        ```

- POST `/logout`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Success Response
        ```json
        {
            "message": "Logout successful"
        }
        ```

- GET `/users`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Parameter
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | q | no | Search users |
    - Success Response
        ```json
        {
            "data": [
                {
                    "name": "M. Iqbal Effendi",
                    "email": "iqbaleff214@gmail.com",
                    "wallet_id": 1,
                    "current_balance": 344000
                },
                {
                    "name": "Mahda Nurdiana",
                    "email": "mahdanurdiana@gmail.com",
                    "wallet_id": 2,
                    "current_balance": 705000
                }
            ]
        }
        ```

- GET `/teams`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Parameter
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | q | no | Search teams |
    - Success Response
        ```json
        {
            "data": [
                {
                    "name": "First Team",
                    "wallet_id": 3,
                    "current_balance": 0
                },
                {
                    "name": "Second Team",
                    "wallet_id": 4,
                    "current_balance": 0
                },
                {
                    "name": "Third Team",
                    "wallet_id": 5,
                    "current_balance": 0
                }
            ]
        }
        ```

- GET `/stocks`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Parameter
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | q | no | Search stocks |
    - Success Response
        ```json
        {
            "data": [
                {
                    "name": "Stock A",
                    "quantity": 90,
                    "price": "90000.0",
                    "wallet_id": 6,
                    "current_balance": 1000
                },
                {
                    "name": "Stock B",
                    "quantity": 10,
                    "price": "900000.0",
                    "wallet_id": 7,
                    "current_balance": 0
                },
                {
                    "name": "Stock C",
                    "quantity": 5,
                    "price": "1000000.0",
                    "wallet_id": 8,
                    "current_balance": 0
                }
            ]
        }
        ```

- GET `/stocks/price_all`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Success Response
        ```json
        {
            "data": [
                {
                    "identifier": "NIFTY 50",
                    "change": 27.25,
                    "dayHigh": 25445.7,
                    "dayLow": 25336.2,
                    "lastPrice": 25383.75,
                    "lastUpdateTime": "16-Sep-2024 16:00:00",
                    "meta": {
                        "companyName": null,
                        "industry": null,
                        "isin": null
                    },
                    "open": 25406.65,
                    "pChange": 0.11,
                    "perChange30d": 2.1,
                    "perChange365d": 29.85,
                    "previousClose": 25356.5,
                    "symbol": "NIFTY 50",
                    "totalTradedValue": 187049240982.16,
                    "totalTradedVolume": 168694880,
                    "yearHigh": 25445.7,
                    "yearLow": 18837.85
                },
                {
                    "identifier": "BAJFINANCEEQN",
                    "change": -256.5,
                    "dayHigh": 7680,
                    "dayLow": 7322,
                    "lastPrice": 7342,
                    "lastUpdateTime": "16-Sep-2024 15:59:47",
                    "meta": {
                        "companyName": "Bajaj Finance Limited",
                        "industry": "Non Banking Financial Company (NBFC)",
                        "isin": "INE296A13011"
                    },
                    "open": 7680,
                    "pChange": -3.38,
                    "perChange30d": 7.07,
                    "perChange365d": -1.65,
                    "previousClose": 7598.5,
                    "symbol": "BAJFINANCE",
                    "totalTradedValue": 19973322583.350002,
                    "totalTradedVolume": 2679555,
                    "yearHigh": 8192,
                    "yearLow": 6187.8
                }
            ]
        }
        ```

- GET `/wallet/:source_wallet_id`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Success Response
        ```json
        {
            "data": {
                "id": 1,
                "balance": 344000,
                "created_at": "2024-10-03T00:29:04.053Z",
                "updated_at": "2024-10-03T02:08:34.375Z"
            }
        }
        ```

- GET `/transaction/:source_wallet_id/debit`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Success Response
        ```json
        {
            "data": [
                {
                    "id": 2,
                    "source_wallet_id": 1,
                    "target_wallet_id": null,
                    "amount": "500000.0",
                    "transaction_type": "debit",
                    "created_at": "2024-10-03T00:47:14.399Z",
                    "updated_at": "2024-10-03T00:47:14.399Z"
                },
                {
                    "id": 3,
                    "source_wallet_id": 1,
                    "target_wallet_id": 2,
                    "amount": "50000.0",
                    "transaction_type": "transfer",
                    "created_at": "2024-10-03T00:56:46.601Z",
                    "updated_at": "2024-10-03T00:56:46.601Z"
                },
                {
                    "id": 4,
                    "source_wallet_id": 1,
                    "target_wallet_id": 2,
                    "amount": "50000.0",
                    "transaction_type": "transfer",
                    "created_at": "2024-10-03T00:57:04.108Z",
                    "updated_at": "2024-10-03T00:57:04.108Z"
                },
                {
                    "id": 5,
                    "source_wallet_id": 1,
                    "target_wallet_id": 2,
                    "amount": "55000.0",
                    "transaction_type": "transfer",
                    "created_at": "2024-10-03T00:57:13.133Z",
                    "updated_at": "2024-10-03T00:57:13.133Z"
                },
                {
                    "id": 8,
                    "source_wallet_id": 1,
                    "target_wallet_id": null,
                    "amount": "550000.0",
                    "transaction_type": "debit",
                    "created_at": "2024-10-03T01:32:31.627Z",
                    "updated_at": "2024-10-03T01:32:31.627Z"
                },
                {
                    "id": 10,
                    "source_wallet_id": 1,
                    "target_wallet_id": null,
                    "amount": "550000.0",
                    "transaction_type": "debit",
                    "created_at": "2024-10-03T01:32:42.866Z",
                    "updated_at": "2024-10-03T01:32:42.866Z"
                },
                {
                    "id": 11,
                    "source_wallet_id": 1,
                    "target_wallet_id": 2,
                    "amount": "550000.0",
                    "transaction_type": "transfer",
                    "created_at": "2024-10-03T01:34:41.481Z",
                    "updated_at": "2024-10-03T01:34:41.481Z"
                },
                {
                    "id": 12,
                    "source_wallet_id": 1,
                    "target_wallet_id": 6,
                    "amount": "1000.0",
                    "transaction_type": "transfer",
                    "created_at": "2024-10-03T02:08:34.370Z",
                    "updated_at": "2024-10-03T02:08:34.370Z"
                }
            ]
        }
        ```

- GET `/transaction/:source_wallet_id/credit`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Success Response
        ```json
        {
            "data": [
                {
                    "id": 1,
                    "source_wallet_id": null,
                    "target_wallet_id": 1,
                    "amount": "1000000.0",
                    "transaction_type": "credit",
                    "created_at": "2024-10-03T00:44:20.732Z",
                    "updated_at": "2024-10-03T00:44:20.732Z"
                },
                {
                    "id": 6,
                    "source_wallet_id": null,
                    "target_wallet_id": 1,
                    "amount": "550000.0",
                    "transaction_type": "credit",
                    "created_at": "2024-10-03T01:31:12.470Z",
                    "updated_at": "2024-10-03T01:31:12.470Z"
                },
                {
                    "id": 7,
                    "source_wallet_id": null,
                    "target_wallet_id": 1,
                    "amount": "550000.0",
                    "transaction_type": "credit",
                    "created_at": "2024-10-03T01:31:15.546Z",
                    "updated_at": "2024-10-03T01:31:15.546Z"
                },
                {
                    "id": 9,
                    "source_wallet_id": null,
                    "target_wallet_id": 1,
                    "amount": "550000.0",
                    "transaction_type": "credit",
                    "created_at": "2024-10-03T01:32:38.355Z",
                    "updated_at": "2024-10-03T01:32:38.355Z"
                }
            ]
        }
        ```

- POST `/transaction/credit`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Body
        | Field | Required |
        | ---- | -- |
        | target_wallet_id | yes |
        | amount | yes |
    - Success Response
        ```json
        {
            "message": "Deposit successful",
            "balance": 354000
        }
        ```

- POST `/transaction/debit`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Body
        | Field | Required |
        | ---- | -- |
        | source_wallet_id | yes |
        | amount | yes |
    - Success Response
        ```json
        {
            "message": "Withdraw successful",
            "balance": 354000
        }
        ```

- POST `/transaction/transfer`
    - Header
        | Field | Required | Description |
        | ----- | -------- | ------ |
        | Authorization | yes | `token` from `/login` |
    - Body
        | Field | Required |
        | ---- | -- |
        | source_wallet_id | yes |
        | target_wallet_id | yes |
        | amount | yes |
    - Success Response
        ```json
        {
            "message": "Transfer successful",
            "balance": 1000
        }
        ```