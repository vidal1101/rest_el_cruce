/*
 * Script de la tabla Trabajador, donde valida el login
 * stp de recibe los datos CEDULA, CONTRASEÑA
 * Verifica si existe algún registro.
 *	SI: Retorna los datos del usuario
 *	NO: Retorna falso 
 */

DELIMITER //                 #spt de Login
CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `pa_login`(
IN pcedula INT,
IN pcontrasena TEXT
-- OUT existe BOOLEAN
-- OUT mensaje VARCHAR(25)
)

BEGIN

	IF EXISTS (SELECT cedula FROM Trabajador 
			   WHERE contrasenia = $pcontrasena AND cedula = $pcedula) THEN
		
        SELECT cedula, nombre, puesto FROM Trabajador 
			   WHERE contrasenia = $pcontrasena AND cedula = $pcedula;
-- 		SET $existe  = 1;
--      SET $mensaje = 'Usuario encontrado.';
        
-- 	ELSE 
-- 		SET $existe  = 0;
--      SET $mensaje = 'Error. El usuario no existe.';
	END IF;
END //
DELIMITER ;
