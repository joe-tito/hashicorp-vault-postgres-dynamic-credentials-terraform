import Vault from 'node-vault';

export const handler = async (event, context) => {

    var vault = Vault({
        apiVersion: 'v1',
        endpoint: process.env.VAULT_URL,
        token: process.env.VAULT_TOKEN, // Using token for demo purposes. Use more secure auth (i.e., IAM) in practice
        namespace: 'admin'
    })

    const secret = await vault.read('database/creds/demo-role');

    console.log(secret);

    return {
        
        message: 'This is for demo purposes. Seriously, don\'t do this IRL. ',
        credentials: {
            username: secret.data.username,
            password: secret.data.password,
        }
    }
    
}