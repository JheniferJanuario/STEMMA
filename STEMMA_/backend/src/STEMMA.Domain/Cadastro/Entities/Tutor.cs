namespace STEMMA.Domain.Cadastro.Entities;

public class Tutor
{
    public string Nome { get; private set; }

    public Tutor(string nome)
    {
        if(string.IsNullOrWhiteSpace(nome))
            throw new Exception("Nome obrigatório");

        Nome = nome;
    }
}