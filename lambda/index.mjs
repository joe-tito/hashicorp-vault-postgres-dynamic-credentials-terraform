import Vault from 'node-vault';

const {
    VAULT_SECRET_PATH,
    VAULT_PROXY_SERVER_HOST
} = process.env;


export const handler = async (event, context) => {

    const vault = Vault({
        apiVersion: 'v1',
        endpoint: VAULT_PROXY_SERVER_HOST,
        extension: {
            awsLambda: {
                functionName: 'vault-lambda-function',
                logLevel: 'trace'
            }
        }
    });
    
    console.log("Reading Data")
    console.log(VAULT_SECRET_PATH);

    try {
        console.log("Read From Proxy Server")

        const secret = await vault.read(VAULT_SECRET_PATH);
        console.log(secret.err)

        console.log(secret);

        console.log(`secret1: ${secret.data.data['secret1']}`);
        console.log(`secret2: ${secret.data.data['secret2']}`);
    }
    catch (err) {
        console.log(err)
        console.log(err.message);
        console.log(err.response);
    }
    console.log("Finished Reading Data")
}