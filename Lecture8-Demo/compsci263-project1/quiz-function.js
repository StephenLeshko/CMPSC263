const foo = async (bar,a) => {
    const fetchUserById = id => 
      new Promise(resolve => setTimeout(() => 
      resolve({ userId: id, username: `user${id}` }), id * 1000));  
    const fetchUserRole = username => 
      new Promise(resolve => setTimeout(() => 
      {console.log('#Operation 12#'); resolve(`${username}_role`);}, 1000));
    const logUserRole = async (userId) => {
        const something = await fetchUserById(userId);
        const role = await fetchUserRole(something.username);
        console.log(`${something.username}'s role is ${role}` + ' color: green');
    };  
    await logUserRole(a);
    await logUserRole(bar);
}
foo( 2 , 7 );



