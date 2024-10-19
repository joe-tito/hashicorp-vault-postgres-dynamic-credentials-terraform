import Vault from 'node-vault';

const {
    VAULT_SECRET_PATH,
    VAULT_PROXY_SERVER_HOST
} = process.env;

const readFromProxyServer = async () => {
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
    return await vault.read(VAULT_SECRET_PATH);
}

export const handler = async (event, context) => {
    
    console.log("Reading Data")

    try {
        console.log("Read From Proxy Server")

        const secret = await readFromProxyServer();

        console.log(secret);

        console.log(`secret1: ${secret.data.data['secret1']}`);
        console.log(`secret2: ${secret.data.data['secret2']}`);
    }
    catch (err) {
        console.log(err)
    }
    console.log("Finished Reading Data")
}