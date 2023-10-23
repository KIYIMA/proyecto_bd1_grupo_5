USE base_consorcio;

go

CREATE VIEW vistaAdministrador AS
SELECT apeynom, sexo, fechnac
FROM administrador;

go

SELECT * FROM vistaAdministrador;