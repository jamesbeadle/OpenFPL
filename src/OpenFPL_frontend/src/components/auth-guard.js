import { useContext, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { AuthContext } from '../contexts/AuthContext';

export const AuthGuard = ({ children }) => {
  const { isAuthenticated, loading, initialized } = useContext(AuthContext);
  const navigate = useNavigate();

  useEffect(() => {
    if (initialized && !loading && !isAuthenticated) {
      navigate("/");
    }
  }, [isAuthenticated, loading, initialized]);
  

  if (loading) {
    return;
  }

  return isAuthenticated ? children : null;
  
};
