DELIMITER //

CREATE PROCEDURE recorrer_documentos()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tipo_doc_nombre VARCHAR(255);
    DECLARE numero_doc VARCHAR(15);
    DECLARE fecha_exp DATE;

    DECLARE cur CURSOR FOR
        SELECT td.Nombre, d.numero_documento, d.fecha_expedicion
        FROM documentos d
        JOIN tipo_documento td ON d.id_tipodocumento = td.ID_TipoDoc;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_resultado (
        info VARCHAR(500)
    );

    OPEN cur;

    leer_loop: LOOP
        FETCH cur INTO tipo_doc_nombre, numero_doc, fecha_exp;
        IF done THEN
            LEAVE leer_loop;
        END IF;

        INSERT INTO tmp_resultado(info)
        VALUES (
            CONCAT('Tipo: ', tipo_doc_nombre, ' | Número: ', numero_doc, ' | Fecha Expedición: ', fecha_exp)
        );
    END LOOP;

    CLOSE cur;

    SELECT * FROM tmp_resultado;

    DROP TEMPORARY TABLE IF EXISTS tmp_resultado;
END$$

DELIMITER //





USE document_recovery;

CALL recorrer_documentos();

