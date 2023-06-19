import React, { useState, useContext } from 'react';
import { Modal, Button, Form, Spinner } from 'react-bootstrap';
import { OpenFPL_backend as open_fpl_backend } from '../../../../declarations/OpenFPL_backend';
import { Actor } from "@dfinity/agent";
import { AuthContext } from "../../contexts/AuthContext";

const WithdrawICPModal = ({ show, onHide, balance, wallet }) => {
  
  const { authClient } = useContext(AuthContext);
  const [isLoading, setIsLoading] = useState(false);
  const [withdrawAmount, setWithdrawAmount] = useState(0);
  const [withdrawError, setWithdrawError] = useState(null);
  const withdrawalFee = 0.0001; 

  const handleSubmit = async (event) => {
    event.preventDefault();
    setIsLoading(true);
    

    let validWithdrawal = await isWithdrawalAmountValid();
    
    if (!validWithdrawal) {
        setIsLoading(false);
        return;
    }

    let validWithdrawalWallet = await isWithdrawalWalletValid();
    
    if (!validWithdrawalWallet) {
        setIsLoading(false);
        return;
    }

    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    await open_fpl_backend.withdrawICP(withdrawAmount - withdrawalFee);

    setWithdrawAmount(0);
    setWithdrawError(null);
    onHide(true);
  };

  const isWithdrawalAmountValid = async () => {
    
    if(withdrawAmount > balance){
      setWithdrawError("You don't have enough to withdraw that amount.");
      return false;
    }

    if(withdrawAmount == 0){
      setWithdrawError("Cannot withdraw nothing.");
      return false;
    }

    if(withdrawAmount <= withdrawalFee){
      setWithdrawError("Please withdraw more than the withdrawal fee.");
      return false;
    }
    
    setWithdrawError(null);
    
    return true;
  };

  const isWithdrawalWalletValid = async () => {
    if(authClient == null){
      return;
    }
    const identity = authClient.getIdentity();
    Actor.agentOf(open_fpl_backend).replaceIdentity(identity);
    const isValid = await open_fpl_backend.isWalletValid(wallet);
  
    if (isValid) {
      setWithdrawError(null);
    } else {
      setWithdrawError('Invalid wallet address.');
    }
  
    return isValid;
  };

  const hideModal = () => {
    setWithdrawAmount(0);
    setWithdrawError(null);
    onHide(false);
  };

  return (
    <Modal show={show} onHide={hideModal}>
      {isLoading && (
        <div className="customOverlay d-flex flex-column align-items-center justify-content-center">
          <Spinner animation="border" />
          <p className='text-center mt-1'>Withdrawing ICP</p>
        </div>
      )}
      <Modal.Header closeButton>
        <Modal.Title>Withdraw ICP</Modal.Title>
      </Modal.Header>
      <Modal.Body>
      <div className="table-responsive">
        <Form onSubmit={handleSubmit}>
            <p><strong>Account Balance:</strong> {(Number(balance) / 1e8).toFixed(4)} ICP</p>
            
            <p className='mt-1'><strong>Withdrawal Address:</strong><br />
              <small className='text-break'>{wallet}</small></p>
            
            <Form.Group className='mt-3' controlId="withdrawAmount">
              <Form.Label>Amount</Form.Label>
              <Form.Control
                  type="number"
                  min="0"
                  step="0.01"
                  placeholder="Enter amount to withdraw"
                  value={withdrawAmount}
                  onChange={(event) => setWithdrawAmount(event.target.value)}
              />
              {withdrawError && <Form.Text className="text-danger">{withdrawError}</Form.Text>}
            </Form.Group>
            <p>We will take the withdrawal fee of {withdrawalFee} ICP off your withdrawal amount.</p>
        </Form>
      </div>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={hideModal}>Cancel</Button>
        <Button onClick={handleSubmit}>Withdraw</Button>
      </Modal.Footer>
    </Modal>
    
  );
};

export default WithdrawICPModal;
