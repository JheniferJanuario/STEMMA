namespace STEMMA.Domain.Cadastro.Entities;

public class Pet
{
    public string Nome { get; private set; }

    public Pet(string nome)
    {
        Nome = nome;
    }
}