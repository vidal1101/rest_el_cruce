
DELIMITER //

CREATE DEFINER = `adminRestBar`@`localhost` TRIGGER `` BEFORE INSERT ON account
	FOR EACH ROW SET @sum = @sum + NEW.amount;
    
END;
DELIMITER //