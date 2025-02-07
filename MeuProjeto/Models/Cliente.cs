namespace MeuProjeto.Models
{
    public class Cliente
    {
        public string CPF { get; set; }
        public string Nome { get; set; }
        public string CEP { get; set; }
        public string Endereco { get; set; }
        public string Produto { get; set; }
        public DateTime? DataCompra { get; set; } 

    }
}
