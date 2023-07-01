import React from 'react';
import { GB, US, DE, FR } from 'country-flag-icons/react/3x2'

// Mapping from country names to their alpha-2 codes
const countryNameToCode = {
  'England': 'GB',
  'United States': 'US',
  'Germany': 'DE',
  'France': 'FR',
  // Add more countries here...
};

// Create an object that maps the flags to the country codes
const flags = {
  'GB': <GB title='United Kingdom' style={{width: "20px"}} />,
  'US': <US title='United States' style={{width: "20px"}} />,
  'DE': <DE title='Germany' style={{width: "20px"}} />,
  'FR': <FR title='France' style={{width: "20px"}} />,
  // Add more flags here...
};

// The function that maps a country name to a flag component
const getFlag = (countryName) => {
  // Get the alpha-2 code
  const code = countryNameToCode[countryName];
  // Return the flag component, or null if the country is not in our mapping
  return flags[code] || null;
}

export default getFlag;
