import React, {useState} from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  NativeModules,
  Pressable,
  TextInput
} from 'react-native';
const App = () => {
  const onLoginPressed = () => {
    setIsLoggedIn(true);
    NativeModules.LoginViewEventManager.onLoginSuccess({token: "abc"});
  }
  const onLogoutPressed = () => {
    setIsLoggedIn(false);
    NativeModules.LoginViewEventManager.onLogoutSuccess();
  }
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  return (
    <View style={styles.container}>
      {!isLoggedIn ? (
        <View>
          <Text style={styles.label}>Log in</Text>
      <TextInput style={styles.textInput} placeholder="Username" value={username} onChangeText={setUsername} />
      <TextInput style={styles.textInput} placeholder="Password" value={password} onChangeText={setPassword} />
      <Pressable style={styles.button} onPress={onLoginPressed}>
        <Text style={{color: 'white'}}>Login</Text>
      </Pressable>
   </View>
      ) : (
      <Pressable style={styles.button} onPress={onLogoutPressed}>
        <Text style={{color: 'white'}}>Logout</Text>
      </Pressable>)}
    </View>
  );
};
var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 30
  },
  label: {
    fontSize: 20,
    paddingVertical: 10
  },
  textInput: {
    padding: 10,
    borderRadius: 5,
    borderWidth: 1,
    borderColor: 'gray',
    marginBottom: 10
  },
  button: {
    backgroundColor: 'blue',
    padding: 20,
    borderRadius: 5
  },
});

export default App;