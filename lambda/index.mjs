import Vault from 'node-vault';

const {
    VAULT_SECRET_PATH,
    VAULT_PROXY_SERVER_HOST,
    VAULT_TOKEN
} = process.env;


export const handler = async (event, context) => {

    var options = {
        apiVersion: 'v1', // default
        endpoint: 'https://demo-cluster-public-vault-0493af48.3f7d4994.z1.hashicorp.cloud:8200', // default
        token: VAULT_TOKEN // optional client token; can be fetched after valid initialization of the server
    };

        // get new instance of the client
        var vault = require("node-vault")(options);

        const secret = await vault.read('database/cred/demo-role');
        
        console.log(secret);

//     const vault = Vault({
//         apiVersion: 'v1',
//         endpoint: VAULT_PROXY_SERVER_HOST,
//         extension: {
//             awsLambda: {
//                 functionName: 'vault-lambda-function',
//                 logLevel: 'trace'
//             }
//         }
//     });
    
//     console.log("Reading Data")
//     console.log(VAULT_SECRET_PATH);

//     try {
//         console.log("Read From Proxy Server")

//         const secret = await vault.read(VAULT_SECRET_PATH);
//         console.log(secret.err)

//         console.log(secret);

//         console.log(`secret1: ${secret.data.data['secret1']}`);
//         console.log(`secret2: ${secret.data.data['secret2']}`);
//     }
//     catch (err) {
//         console.log(err)
//         console.log(err.message);
//         console.log(err.response);
//     }
//     console.log("Finished Reading Data")
}