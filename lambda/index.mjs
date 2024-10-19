import Vault from 'node-vault';

export const handler = async (event, context) => {

    var vault = Vault({
        apiVersion: 'v1',
        endpoint: 'https://demo-cluster-public-vault-0493af48.3f7d4994.z1.hashicorp.cloud:8200',
        token: process.env.VAULT_TOKEN, // Using token for demo purposes only. Use more secure auth method in practice
        namespace: 'admin'
    })

    const secret = await vault.read('database/creds/demo-role');

    console.log(secret);

    return {
        username: secret.data.username,
        password: secret.data.password,
        message: 'Seriously, don\'t do this IRL'
    }
    
}