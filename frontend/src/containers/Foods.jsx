import React from 'react';

const Foods = ({match}) => {
  return(
    <>
      フード一覧
    <p>
      restaurantsIdは{match.params.restauransId}です
    </p>
    </>
  )
}

export default Foods;
