namespace STEMMA.Domain.Cadastro.Entities;

public class Pet
{
    public Guid Id { get; private set; }

    public string Nome { get; private set; }

    public string Raca { get; private set; }

    public int Idade { get; private set; }

    public decimal Peso { get; private set; }

    public Guid TutorId { get; private set; }

    public Tutor Tutor { get; private set; }

    protected Pet() { }

    public Pet(
        string nome,
        string raca,
        int idade,
        decimal peso,
        Guid tutorId)
    {
        Validar(nome, raca, idade, peso);

        Id = Guid.NewGuid();
        Nome = nome;
        Raca = raca;
        Idade = idade;
        Peso = peso;
        TutorId = tutorId;
    }

    public void AlterarPeso(decimal peso)
    {
        if (peso <= 0)
            throw new Exception("Peso inválido.");

        Peso = peso;
    }

    private void Validar(
        string nome,
        string raca,
        int idade,
        decimal peso)
    {
        if (string.IsNullOrWhiteSpace(nome))
            throw new Exception("Nome do pet obrigatório.");

        if (string.IsNullOrWhiteSpace(raca))
            throw new Exception("Raça obrigatória.");

        if (idade < 0)
            throw new Exception("Idade inválida.");

        if (peso <= 0)
            throw new Exception("Peso inválido.");
    }
}