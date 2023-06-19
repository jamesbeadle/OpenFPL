import React from 'react';

const CopyIcon = ({ onClick }) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width="16"
    height="16"
    fill="currentColor"
    viewBox="0 0 16 16"
    onClick={onClick}
    style={{ cursor: 'pointer' }}
  >
    <path d="M3.5 2a.5.5 0 0 0-.5.5v10a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5v-10a.5.5 0 0 0-.5-.5h-9zM2 2.5A1.5 1.5 0 0 1 3.5 1h9A1.5 1.5 0 0 1 14 2.5v10a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 12.5v-10zm9.5 3A1.5 1.5 0 0 1 13 7h1.5V3.5a1.5 1.5 0 0 0-1.5-1.5H9V4a1.5 1.5 0 0 1 1.5 1.5v1zm0 1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1z" />
  </svg>
);

const ExitIcon = ({className }) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    fill="currentColor"
    viewBox="0 1.5 16 16"
    width="16"
    height="20"
    className={className}
  >
   <path fill-rule="evenodd" d="M14 2.5a.5.5 0 0 0-.5-.5h-6a.5.5 0 0 0 0 1h4.793L2.146 13.146a.5.5 0 0 0 .708.708L13 3.707V8.5a.5.5 0 0 0 1 0v-6z"/>
 </svg>
);




export { CopyIcon, ExitIcon };
