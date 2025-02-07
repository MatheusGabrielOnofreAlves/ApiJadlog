using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

[Route("api/[controller]")]
[ApiController]
public class ClienteController : ControllerBase
{
    private readonly MeuDbContext _dbContext;

    public ClienteController(IConfiguration configuration)
    {
        _dbContext = new MeuDbContext(configuration);
    }

    [HttpGet("{cpf}")]
    public IActionResult GetCliente(string cpf)
    {
        var cliente = _dbContext.GetClientePorCPF(cpf);
        if (cliente == null)
        {
            return NotFound(new { message = "Cliente não encontrado" });
        }
        return Ok(cliente);
    }
}