# Proyecto MCP en API de Museo MuleSoft

## Descripción General
Proyecto utilizado en la Meetup: https://meetups.mulesoft.com/events/details/mulesoft-online-group-spanish-presents-transforma-tu-api-en-herramienta-de-agente-de-ia-desafios-y-soluciones-con-mulesoft/. Donde vimos como se puede "extender" una implementación de API en MuleSoft a server MCP utilizando el conector correspondiente.
La implementación de la API es a modo de referencia, y el objetivo es ver como se configura el conector para que pueda ser utilizado mediante el protocolo MCP.

## Configuración de Runtime
Agrega el siguiente argumento a tu runtime de MuleSoft:

```
-M-Dmule.http.service.implementation=NETTY
```
**Referencia:** https://docs.mulesoft.com/mcp-connector/latest/mcp-connector-acb

## Despliegue de aplicación (local y CH2)
Para poder conectar la API existente con API manager, es necesario, dentro de la organización que utilicemos ( puede ser una trial ) el registro de la API incluída en el código en API manager.
Y luego agregar como parámetros de ejecución (obteniendo los valores según corresponda) en la aplicación : 
```
anypoint.platform.client_secret=
anypoint.platform.client_id=
apiId=
```

## Paquete Gateway
MCPHub es el gateway para que se pueda utilizar el proyecto con Claude u otro agente que solo soporte stdio.

**Instalación:**
```bash
npm install @mcphub/gateway
```

**Referencia:** https://www.npmjs.com/package/@mcphub/gateway

## Inspector del Protocolo de Contexto de Modelo
Para probar y testear el server se puede utilizar la herramienta MCP Inspector.

**Iniciar Inspector:**
```bash
npx @modelcontextprotocol/inspector
```

**Referencia:** https://modelcontextprotocol.io/docs/tools/inspector

## Configuración de Claude Desktop
Para configurar Claude Desktop con este proyecto:

1. Abrir el archivo claude_desktop_config.json de la configuración de Claude
2. Agrega la configuración de tu servidor:
```json
{
  "mcpServers": {
     "museo-mcp": {
				"command": "node",
				"args": ["/{path a node modules}/node_modules/@mcphub/gateway/dist/src/mcphub-gateway.js"],
                 "env": {
                     "MCPHUB_SERVER_URL": "http://localhost:8081"       
                 }
			}
  }
}
```
3. Reinicia Claude Desktop para aplicar los cambios
