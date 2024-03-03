import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import { getGenericPassword, setGenericPassword } from 'react-native-neo-vault';

export default function App() {
  const handleSetGenericPassword = async () => {
    const result = await setGenericPassword('password', 'account');
    console.log(`🐵 ------ result`, result);
  };
  const handleGetGenericPassword = async () => {
    const result = await getGenericPassword();
    console.log(`🐵 ------ result`, result);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.text}>React Native Neo Vault</Text>
      <Button title="Set Generic Password" onPress={handleSetGenericPassword} />
      <Button title="Get Generic Password" onPress={handleGetGenericPassword} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },

  text: {
    fontSize: 32,
  },
  button: {
    fontSize: 20,
    padding: 10,
  },
});
