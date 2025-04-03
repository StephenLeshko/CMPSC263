import React, {useState} from 'react'



export default function Home() {

  const [name, setName] = useState('Stephen')

  function changeName(){
    setName('Peter')
  }

  return (

    <div>
    <button onClick={changeName}>Change name to peter</button>


    <div>{name}</div>
    </div>

  );
}
